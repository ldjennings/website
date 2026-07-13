{
  description = "Personal website experiment using Typst's HTML bundle export";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    press.url = "github:RossSmyth/press";
  };

  outputs =
    { self, nixpkgs, press }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import press) ];
      };

      fs = pkgs.lib.fileset;

      # The webfont files theme.css declares @font-face for, taken verbatim
      # from the pinned packages and served next to the pages as fonts/.
      # Future work: subset + convert to woff2 during the build.
      webFonts = pkgs.runCommand "site-webfonts" { } ''
        mkdir -p "$out"
        cp ${pkgs.alegreya}/share/fonts/opentype/Alegreya-{Regular,Italic,Medium,MediumItalic,Bold,BoldItalic}.otf "$out/"
        cp ${pkgs.atkinson-hyperlegible}/share/fonts/opentype/AtkinsonHyperlegible-{Regular,Italic,Bold}.otf "$out/"
        cp ${pkgs.atkinson-hyperlegible-mono}/share/fonts/opentype/AtkinsonHyperlegibleMono-{Regular,Bold}.otf "$out/"
      '';

      # The 3D model viewer (post.typ's fig3d) and the decoder for its
      # EXT_meshopt_compression models (gltfpack -cc output — see README),
      # self-hosted next to the pages as js/ so no page touches a CDN.
      # Pinned like the webfonts: fetched by hash here, never committed.
      viewerJs = {
        # 4.2.0, deliberately not latest: the 4.3.x bundles ship leftover
        # debug console.log spam.
        "model-viewer.min.js" = pkgs.fetchurl {
          url = "https://cdn.jsdelivr.net/npm/@google/model-viewer@4.2.0/dist/model-viewer.min.js";
          hash = "sha256-F9gKt0f1HOAMa47XV4R0Q/nk+6V16+5ZmkIt8wrwn88=";
        };
        "meshopt_decoder.js" = pkgs.fetchurl {
          url = "https://cdn.jsdelivr.net/npm/meshoptimizer@0.24.0/meshopt_decoder.js";
          hash = "sha256-xEeVuoxDqJeUMoQX039Lpdqs9Cb2EiT6hBuBgDhojS0=";
        };
      };
      copyViewerJs = dest: pkgs.lib.concatStrings (
        pkgs.lib.mapAttrsToList (name: file: ''
          cp -f ${file} "${dest}/${name}"
        '') viewerJs
      );

      # Only the files the site build needs, copied into the sandbox.
      siteSrc = fs.toSource {
        root = ./src;
        fileset = fs.unions [
          ./src/main.typ
          ./src/lib
          ./src/pages
          ./src/assets
        ];
      };

      site = pkgs.buildTypstDocument {
        pname = "website";
        version = "0.1";
        src = siteSrc;
        file = "main.typ";

        # Fonts the documents use, pinned through nix. press wraps typst with
        # TYPST_FONT_PATHS pointing at these, so the sandbox build, the
        # devshell, and the nix apps below all resolve identical fonts —
        # whether or not they exist on the host system.
        fonts = [
          pkgs.libertinus # typst's default text face
          pkgs.alegreya # display face (headings, brand)
          pkgs.atkinson-hyperlegible # body face
          pkgs.atkinson-hyperlegible-mono # code face
        ];

        creationTimestamp = self.lastModified;
        format = "bundle";

        # press only knows to add `--features html` when format == "html";
        # bundle export needs both experimental flags, so append them here.
        # Bundle output is a directory tree (one file per #document/#asset),
        # written into $out directly — the finished site, ready to serve.
        # After typst runs, hoist the in-body <meta>/<link>/<base> tags into
        # <head> — typst can't emit there itself, and Firefox flashes
        # unstyled content when the stylesheets load from <body>. The script
        # fails the build once typst starts doing this on its own.
        buildPhase = ''
          runHook preBuild
          mkdir -p "$out"
          typst "''${typstArgs[@]}" --features html,bundle "$out/"
          ${pkgs.lib.getExe pkgs.python3} ${./tools/hoist-head.py} "$out"
          mkdir -p "$out/fonts" "$out/js"
          cp ${webFonts}/* "$out/fonts/"
          ${copyViewerJs "$out/js"}
          runHook postBuild
        '';
      };

      # Dev-loop commands as nix apps, using the same wrapped typst (pinned
      # fonts + packages) as the sandbox build. --ignore-system-fonts keeps
      # local compiles from resolving fonts the sandbox won't have.
      # Run from the repo root: they read src/ and write build/.
      mkSiteApp =
        name: verb:
        pkgs.writeShellApplication {
          name = "site-${name}";
          runtimeInputs = [ site.typst-wrapped ];
          text =
            ''
              mkdir -p build/fonts build/js
              cp -f ${webFonts}/* build/fonts/
              ${copyViewerJs "build/js"}
            ''
            # watch never exits and rewrites pages on every change, so the
            # head hoist (see buildPhase) can't run here: dev pages keep
            # typst's in-body tags. Harmless — only the Firefox unstyled
            # flash fix is missing from the live loop.
            + (
              if verb == "watch" then
                ''
                  exec typst watch --features html,bundle --format bundle \
                    --ignore-system-fonts src/main.typ build/
                ''
              else
                ''
                  typst compile --features html,bundle --format bundle \
                    --ignore-system-fonts src/main.typ build/
                  ${pkgs.lib.getExe pkgs.python3} ${./tools/hoist-head.py} build/
                ''
            );
        };
    in
    {
      # `nix build` produces result/ with the compiled site.
      packages.${system}.default = site;

      # `nix flake check` builds the site and audits it for dead links
      # (every local href/src must resolve to a file, fragments to an id).
      checks.${system} = {
        site-builds = site;
        link-audit = pkgs.runCommand "link-audit" { } ''
          ${pkgs.lib.getExe pkgs.python3} ${./tools/check-links.py} ${site}
          touch "$out"
        '';
      };

      # `nix run .#watch` / `nix run .#build` — replicable dev loop.
      apps.${system} = {
        watch = {
          type = "app";
          program = pkgs.lib.getExe (mkSiteApp "watch" "watch");
        };
        build = {
          type = "app";
          program = pkgs.lib.getExe (mkSiteApp "build" "compile");
        };
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
        # Brings the wrapped typst (with feature flags available) from the site build.
        inputsFrom = [ site ];
        packages = with pkgs; [
          tinymist
          python3
          just
        ];

        # Stable, workspace-relative handle on the pinned font env (press's
        # inherited shellHook has already exported TYPST_FONT_PATHS by the
        # time this runs). tinymist.fontPaths in .vscode/settings.json points
        # here, so editor diagnostics resolve the same fonts as the builds
        # even when the editor wasn't launched from the devshell.
        shellHook = ''
          mkdir -p .direnv
          ln -sfn "''${TYPST_FONT_PATHS%%:*}" .direnv/site-fonts
        '';
      };
    };
}

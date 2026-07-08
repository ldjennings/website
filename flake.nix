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
          pkgs.junicode # used by the PDF documents
        ];

        creationTimestamp = self.lastModified;
        format = "bundle";

        # press only knows to add `--features html` when format == "html";
        # bundle export needs both experimental flags, so append them here.
        # Bundle output is a directory tree (one file per #document/#asset),
        # written into $out directly — the finished site, ready to serve.
        buildPhase = ''
          runHook preBuild
          mkdir -p "$out"
          typst "''${typstArgs[@]}" --features html,bundle "$out/"
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
          text = ''
            exec typst ${verb} --features html,bundle --format bundle \
              --ignore-system-fonts src/main.typ build/
          '';
        };
    in
    {
      # `nix build` produces result/ with the compiled site.
      packages.${system}.default = site;

      # `nix flake check` builds the site.
      checks.${system}.site-builds = site;

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

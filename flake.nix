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
    in
    {
      # `nix build` produces result/ with the compiled site.
      packages.${system}.default = site;

      # `nix flake check` builds the site.
      checks.${system}.site-builds = site;

      devShells.${system}.default = pkgs.mkShellNoCC {
        # Brings the wrapped typst (with feature flags available) from the site build.
        inputsFrom = [ site ];
        packages = with pkgs; [
          tinymist
          python3
          just
        ];
      };
    };
}

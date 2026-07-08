out := "build"

default: watch

# Recompile into build/ on every source change.
# Runs through the flake so typst, feature flags, and fonts are all pinned.
watch:
    nix run .#watch

# One-shot compile into build/.
build:
    nix run .#build

# Serve build/ locally (live view at http://localhost:8000).
serve port="8000":
    python3 -m http.server {{port}} -d {{out}}

# Reproducible build via the flake (output in result/).
nix-build:
    nix build

check:
    nix flake check

clean:
    rm -rf {{out}} result

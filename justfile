# Bundle export is experimental in typst 0.15 and gated behind feature flags.
typst-args := "--features html,bundle --format bundle"
out := "build"

default: watch

# Recompile into build/ on every source change.
watch:
    typst watch {{typst-args}} src/main.typ {{out}}/

# One-shot compile into build/.
build:
    typst compile {{typst-args}} src/main.typ {{out}}/

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

# typst-bundle-test

Experiment: building a personal website with [Typst's experimental bundle
export](https://typst.app/docs/reference/html/) (typst 0.15, `--features
html,bundle`), instead of a conventional static site generator. The sidebar
layout is modeled on [web.youwen.dev](https://web.youwen.dev/)
([source](https://github.com/youwen5/web)), which does the same thing with a
custom Hakyll setup.

## Usage

Everything runs inside the flake devshell (`nix develop`, or direnv).

| Command | What it does |
| --- | --- |
| `just` / `just watch` | recompile into `build/` on every change |
| `just serve` | serve `build/` at <http://localhost:8000> |
| `just build` | one-shot compile into `build/` |
| `nix build` | reproducible build via [press](https://github.com/RossSmyth/press) → `result/` |
| `nix flake check` | CI-style check that the site builds |

Typical loop: `just watch` in one terminal, `just serve` in another.

## Layout

All project code lives under `src/`, split into layers, roughly
stagecraft-themed:

| Layer | Where | Role |
| --- | --- | --- |
| Set dressing | `src/lib/dressing.typ` | site name, nav links, logo — what the chrome *says* |
| Skeleton | `src/lib/skeleton.typ` | `webpage()` wrapper emitting the sidebar / mobile header around each page |
| Formatting | `src/assets/main.css` | all visual styling (palette, layout, responsive breakpoints) |
| Pages | `src/pages/*.typ` | one file per webpage; each calls `webpage(path, title: ..)[content]` |
| Staging | `src/main.typ` | `#include`s every page and `#asset`s the shared static files |

Cross-page links use ordinary Typst labels: `#webpage(..)[..] <blog>` in one
file, `#link(<blog>)[..]` in another — the bundle export rewrites them to
relative hrefs.

## Caveats

- Bundle export is experimental; the CLI warns on every compile and the
  interface may change.
- Typst currently emits `<link rel="stylesheet">` at the top of `<body>`
  rather than hoisting it into `<head>`. Browsers apply it fine, but it is
  technically non-conforming HTML.
- Nix flakes only see git-tracked files: `git add` new source files or
  `nix build` will fail to find them.

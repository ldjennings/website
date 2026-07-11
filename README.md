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
| Skeleton | `src/lib/skeleton.typ` | `webpage()` wrapper emitting the sidebar / mobile header / colophon around each page |
| Props | `src/lib/cards.typ`, `src/lib/post.typ` | project cards + article rows for the landing page; the long-form post template (`post()`, `fig()`, `btn()`, `post-nav()`) |
| Formatting | `src/assets/layout.css` + `src/assets/theme.css` | structure vs. theme (everforest role variables, light+dark, self-hosted `@font-face`) |
| Pages | `src/pages/*.typ` | one file per webpage; each calls `webpage(path, title: ..)[content]`. Write-ups live under `posts/` in the bundle — `webpage()` derives the `../` prefix for chrome assets from the path |
| Staging | `src/main.typ` | `#include`s every page and `#asset`s the shared static files |

The resume comes in as a flake input (`github.com/ldjennings/Resume`,
fetched over SSH — it's private): its exported PDF + SVG are copied into
the bundle as `resume.pdf` / `resume.svg`, and `src/pages/resume.typ`
frames the SVG sheet in the site chrome with a PDF download button. (An
HTML-text edition of the CV was tried and rejected — the typeset sheet
looks better and has no content drift.) After pushing resume changes,
run `nix flake update resume`.

The design itself (layout, theme, decisions log) was settled in
`design/mockup/` — see `design/README.md`. Webfont files are copied from
the nix-pinned font packages (Alegreya, Atkinson Hyperlegible + Mono) into
`fonts/` by the flake, so visitors get the same faces the flake pins for
the PDF outputs (future work: subset + woff2-convert them in the build).

Cross-page links use ordinary Typst labels: `#webpage(..)[..] <home>` in
one file, `#link(<home>)[..]` in another — the bundle export rewrites them
to relative hrefs, including fragments (a labeled heading like
`= writing <writing>` resolves to `index.html#writing` from other pages).
The nav in `dressing.typ` accepts either labels or URL strings as
destinations. Note: typst only emits an element id when its label is
actually referenced somewhere.

## Caveats

- Bundle export is experimental; the CLI warns on every compile and the
  interface may change.
- Typst currently emits `<link rel="stylesheet">` at the top of `<body>`
  rather than hoisting it into `<head>`. Browsers apply it fine, but it is
  technically non-conforming HTML.
- Nix flakes only see git-tracked files: `git add` new source files or
  `nix build` will fail to find them.

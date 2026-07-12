# website

Personal website ([jenningsliamd.me](https://jenningsliamd.me)), built with
[Typst's experimental bundle
export](https://typst.app/docs/reference/html/) (typst 0.15, `--features
html,bundle`) instead of a conventional static site generator. The sidebar
layout is modeled on [web.youwen.dev](https://web.youwen.dev/)
([source](https://github.com/youwen5/web)), which does the same thing with a
custom Hakyll setup. It replaces the previous Jekyll site, which lives on
in this repo's history.

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
| Pages | `src/pages/*.typ`, `src/pages/posts/*.typ` | one file per webpage; each calls `webpage(path, title: ..)[content]`. Write-up sources sit in `pages/posts/`, mirroring their `posts/` paths in the bundle — `webpage()` derives the `../` prefix for chrome assets from the path |
| Staging | `src/main.typ` | `#include`s every page and `#asset`s the shared static files |

The resume sheet lives at `src/assets/resume.{pdf,svg}`, committed here
by the (private) Resume repo's CI whenever a new one is published — see
Deployment below. `src/main.typ` bundles the pair as `resume.pdf` /
`resume.svg`, and `src/pages/resume.typ` frames the SVG sheet in the site
chrome with a PDF download button. (An HTML-text edition of the CV was
tried and rejected — the typeset sheet looks better and has no content
drift.)

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

## Deployment

`.github/workflows/deploy.yml` builds the site with nix (including the
`nix flake check` link audit) and publishes it to GitHub Pages on every
push to main. No repo secrets needed; the only setting is Pages deploying
from **GitHub Actions** (Settings → Pages → Build and deployment), with
the custom domain configured there — no `CNAME` file needed under Actions
deploys.

Resume updates: pushing the Resume repo's `website` branch runs its
`publish.yml`, which builds the sheet and commits it here as
`src/assets/resume.{pdf,svg}` (over the write deploy key it holds, as in
the Jekyll era) — and that push deploys like any other.

## Caveats

- Bundle export is experimental; the CLI warns on every compile and the
  interface may change.
- Typst currently emits `<link rel="stylesheet">` (and the other head
  tags) at the top of `<body>` rather than in `<head>` — non-conforming
  HTML, and Firefox paints unstyled content while in-body stylesheets
  load. The build fixes this by rewriting the pages afterwards
  (`tools/hoist-head.py`); the script *fails* when it finds nothing to
  move, so a typst release that emits `<head>` content itself will show
  up as a build failure and the step can be retired. `just watch` skips
  the hoist (typst rewrites output continuously), so the dev loop shows
  typst's raw output.
- Nix flakes only see git-tracked files: `git add` new source files or
  `nix build` will fail to find them.

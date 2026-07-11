# Design mockup

The settled look for the site, prototyped in raw HTML/CSS. Deliberately
**not** nix-managed — iteration speed over reproducibility.

**View it**: right-click `mockup/index.html` → "Open with Live Server".
Flip your system color scheme to see dark mode.

## Structure

- `mockup/layout.css` — structure; colors/fonts only via role variables.
- `mockup/theme.css` — the chosen theme: everforest shifted blue-first,
  white dark-mode text, Alegreya + Atkinson Hyperlegible. Light and dark
  via `prefers-color-scheme`.
- `mockup/index.html` — the landing page mockup.
- `mockup/post.html` — the subpage template (blog posts / in-depth
  project write-ups), built from the real Formula Electric write-up. The
  landing page's formula electric links point here so the click-through
  can be felt in Live Server.
- `mockup/img/` — real project images pulled from the live site
  (jenningsliamd.me), plus its logo photo.

Everything is CSS-only interaction (no JS), and **the port into the Typst
bundle export has landed**: `src/` now produces this design (`src/lib/`,
`src/pages/`, `src/assets/`). The mockup stays as the visual reference —
if the design changes, change it here first, then mirror it in `src/`.

## Settled decisions

Reached over several comparison rounds (variants A/B/C, four theme
candidates, and a thumbnail-treatment lab — all deleted once they'd
served):

- Layout: youwen-style sticky sidebar (16rem) + m4xc content order —
  projects first, articles below; page max-width 1440px.
- Project cards: real **untinted screenshots** as 3:1 top bands (gradients
  rejected); equal-height rows; tags pinned to card bottom; whole card
  clickable with real links layered above.
- Hover preview per card (bigger image, badge, full description, links);
  always covers its card fully; touch devices get a `<details>` fallback.
- Articles: whole-row clickable but otherwise plain — deliberately simpler
  than project cards.
- Theme: **everforest, blue-first** (green demoted out; blue leads, aqua
  supports), white dark-mode foreground instead of stock tan.
- Dark mode ships with light mode, same role variables.
- `<meta name="darkreader-lock">` on every page: the site provides its
  own dark theme, so Dark Reader must not recolor it (also fixes its
  first-load two-tone background flash in Firefox).
- Hover previews carry a full-surface link to the same destination as
  the card, so the deployed preview stays clickable.
- Smooth anchor scrolling; colophon footer.
- Fonts: **Alegreya** (display) + **Atkinson Hyperlegible** (body),
  confirmed after seeing them on real content. Loaded from Google Fonts
  in the mockup; pin them in the flake for the Typst build.
- Post template: 46rem prose measure centered in the main column;
  eyebrow (category · date) + title + tags header; bordered figures with
  captions that break out wider than the text; code in **Atkinson
  Hyperlegible Mono**; pine-rule blockquotes; download/source buttons;
  older/newer footer nav. Section h2s keep the diamond accents.

Rejected along the way: editorial/ambiguous layouts where projects and
articles look alike (variant C), Fraunces, literal youwen copying,
gradient thumbnails, tinted screenshots, Rosé Pine / gruvbox / kanagawa.

## Open questions

- Logo/favicon: currently the mountain photo from the live Jekyll site
  (`img/logo.jpg`); decide whether a designed mark replaces it.
- Content, links, images, and writing entries are pulled from the live
  site (jenningsliamd.me) — the writing list reuses dated project
  write-ups until standalone articles exist.
- Card click destination: project page vs GitHub repo.
- Hover-preview trigger: whole card (current, 0.18s delay) vs title only.
- Mobile: sticky header?
- Monospace: **Atkinson Hyperlegible Mono** is in the post template
  (same family as the body face) — pending verdict.
- Webfonts ship as full OTFs copied from the nix packages; subset +
  woff2-convert them during the build eventually.
- Code blocks render unhighlighted (`set raw(theme: none)` in the Typst
  post template) — an everforest tmTheme could bring colors back.

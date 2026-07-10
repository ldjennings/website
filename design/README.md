# Design mockup

The settled look for the site, prototyped in raw HTML/CSS. Deliberately
**not** nix-managed — iteration speed over reproducibility.

**View it**: right-click `variant-a2/index.html` → "Open with Live Server".
Flip your system color scheme to see dark mode.

## Structure

- `variant-a2/layout.css` — structure; colors/fonts only via role variables.
- `variant-a2/theme.css` — the chosen theme: everforest shifted blue-first,
  white dark-mode text, Alegreya + Atkinson Hyperlegible. Light and dark
  via `prefers-color-scheme`.
- `variant-a2/index.html` — the landing page mockup.
- `variant-a2/img/shot-*.png` — stand-in screenshots for the card bands
  until real per-project images exist.

Everything is CSS-only interaction (no JS), so it ports to the static
Typst bundle export (`src/lib/skeleton.typ`, `src/lib/dressing.typ`,
`src/assets/main.css`) when that time comes.

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
- Smooth anchor scrolling; colophon footer.

Rejected along the way: editorial/ambiguous layouts where projects and
articles look alike (variant C), Fraunces, literal youwen copying,
gradient thumbnails, tinted screenshots, Rosé Pine / gruvbox / kanagawa.

## Open questions

- Real project content, links, and per-project screenshots.
- Card click destination: project page vs GitHub repo.
- Hover-preview trigger: whole card (current, 0.18s delay) vs title only.
- Mobile: sticky header?
- Fonts: Alegreya/Atkinson arrived with everforest and look right, but
  haven't been separately stress-tested (long articles, code blocks).

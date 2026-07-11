// Set dressing: site identity and navigation content.
// Change what the site *says* here; how it's laid out lives in skeleton.typ,
// and how it *looks* lives in assets/layout.css + assets/theme.css.

#let site-name = "Liam Jennings"

// Destinations are either URL strings or Typst labels — the bundle export
// resolves labels to relative hrefs across documents (e.g. <writing> on
// the index page becomes index.html#writing from any other page).
#let nav-main = (
  ("Home", <home>),
  ("Blog", <writing>),
)

// (group title, ((text, dest), ...))
#let nav-groups = (
  ("projects", (
    ("all projects", <projects>),
    ("motion planning", "https://jenningsliamd.me/robotics/2026/05/01/motion-planning/"),
    ("formula electric", <formula-electric>),
    ("symbotic co-op", "https://jenningsliamd.me/work/2025/12/15/symbotic/"),
  )),
  ("elsewhere", (
    ("github", "https://github.com/ldjennings"),
    ("email", "mailto:jenningsliamd@gmail.com"),
    ("resume", <resume>),
  )),
)

// Photo carried over from the current live site (52×52 source); doubles as
// the favicon. A designed mark may replace it eventually.
#let logo = html.img(class: "logo", src: "img/logo.jpg", alt: "")

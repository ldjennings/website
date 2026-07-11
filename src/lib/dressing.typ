// Set dressing: site identity and navigation content.
// Change what the site *says* here; how it's laid out lives in skeleton.typ,
// and how it *looks* lives in assets/layout.css + assets/theme.css.

#let site-name = "Liam Jennings"

// Destinations are either URL strings or Typst labels — the bundle export
// resolves labels to relative hrefs across documents (e.g. <writing> on
// the index page becomes index.html#writing from any other page).
#let nav-main = (
  ("Home", <home>),
  ("Writing", <writing>),
  ("About", <about>),
)

// (group title, ((text, dest), ...))
#let nav-groups = (
  ("Projects", (
    ("Showcase", <projects>),
    ("Motion planning", <motion-planning>),
    ("Formula electric", <formula-electric>),
    ("Symbotic co-op", <symbotic>),
  )),
  ("Elsewhere", (
    ("GitHub", "https://github.com/ldjennings"),
    ("Email", "mailto:jenningsliamd@gmail.com"),
    ("Resume", <resume>),
  )),
)

// Photo carried over from the current live site (52×52 source); doubles as
// the favicon. A designed mark may replace it eventually. `root` is the
// page's prefix back to the bundle root (see skeleton.typ).
#let logo(root) = html.img(class: "logo", src: root + "img/logo.jpg", alt: "")

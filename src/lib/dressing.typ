// Set dressing: site identity and navigation content.
// Change what the site *says* here; how it's laid out lives in skeleton.typ,
// and how it *looks* lives in assets/layout.css + assets/theme.css.

#let site-name = "Liam Jennings"

// Destinations are either URL strings or Typst labels — the bundle export
// resolves labels to relative hrefs across documents (e.g. <writing> on
// the index page becomes index.html#writing from any other page).
// An entry may carry a third element — ((text, dest), ...) — rendered as
// a collapsible sub-list under the link (the caret toggles it).
#let nav-main = (
  ("Home", <home>),
  ("Projects", <projects>, (
    ("Motion planning", <motion-planning>),
    ("Symbotic co-op", <symbotic>),
    ("Formula electric", <formula-electric>),
    ("Quadrotor interception", <quadrotor>),
    ("3-DOF robot arm", <robot-arm>),
    ("Single image deraining", <deraining>),
  )),
  ("Writing", <writing>),
)

// Standalone pages — set apart from nav-main, which is all index anchors.
#let nav-pages = (
  ("About", <about>),
)

// Every write-up, oldest first: (file stem, footer-nav title). Drives the
// older/newer footer chain on each post (post-nav in post.typ) — adding a
// post here threads it into its neighbors automatically.
#let post-chain = (
  ("maze-robot", "Maze-Solving ROMI Robots"),
  ("reinforcement-learning", "Reinforcement Learning in ROS"),
  ("deraining", "Single Image Deraining"),
  ("robot-arm", "3-DOF Robot Arm"),
  ("quadrotor", "Quadrotor Interception"),
  ("formula-electric", "Formula Electric"),
  ("symbotic", "Symbotic Co-op"),
  ("motion-planning", "Motion Planning"),
)

// (group title, ((text, dest), ...))
#let nav-groups = (
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

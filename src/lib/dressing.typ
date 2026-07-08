// Set dressing: site identity and navigation content.
// Change what the site *says* here; how it's laid out lives in skeleton.typ,
// and how it *looks* lives in assets/main.css.

#let site-name = "liam jennings"

#let nav-main = (
  ("Home", "index.html"),
  ("Blog", "blog.html"),
)

// (group title, ((label, href), ...))
#let nav-groups = (
  ("documents", (
    ("Blog as a single PDF", "blog.pdf"),
  )),
  ("elsewhere", (
    ("GitHub", "https://github.com/ldjennings"),
  )),
)

// Two overlapping rotated squares, approximating the reference logo in pure CSS.
#let logo = html.elem("span", attrs: (class: "logo"), {
  html.elem("span", attrs: (class: "logo-square logo-rose"))
  html.elem("span", attrs: (class: "logo-square logo-teal"))
})

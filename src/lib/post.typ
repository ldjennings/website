// Long-form post template (blog posts / in-depth project write-ups),
// mirroring design/mockup/post.html. Prose is written in native Typst
// markup — headings, lists, raw blocks, and quotes compile to the elements
// the .post CSS targets; the helpers below cover the classed pieces.

#import "dressing.typ": post-chain

// Captioned image. Branches on export target so the same post body can
// feed both the HTML page and its PDF twin. Posts live in posts/, hence
// the ../ back to the bundle's img/.
#let fig(name, caption, alt: "", width: 75%) = context {
  if target() == "html" {
    html.figure({
      html.img(src: "../img/" + name, alt: alt)
      html.figcaption(caption)
    })
  } else {
    figure(image("../assets/img/" + name, width: width), caption: caption)
  }
}

// Embedded YouTube demo video (HTML pages only; a paged target gets a
// plain link instead).
#let video(id, caption) = context {
  if target() == "html" {
    html.figure({
      html.iframe(
        class: "video-embed",
        src: "https://www.youtube.com/embed/" + id,
        allowfullscreen: true,
      )
      html.figcaption(caption)
    })
  } else {
    [#link("https://www.youtube.com/watch?v=" + id)[#caption (video)]]
  }
}

// Bordered action buttons (source links, PDF downloads); takes one or
// more (label, href) pairs rendered side by side.
#let btn(..pairs) = html.p({
  for (label, href) in pairs.pos() {
    html.a(class: "button", href: href, label)
    [ ]
  }
})

// Older/newer footer navigation, derived from post-chain: pass the post's
// own file stem and its neighbors in the chain are linked (posts are all
// siblings in posts/, so a stem + ".html" is the href).
#let post-nav(name) = {
  let i = post-chain.position(p => p.at(0) == name)
  assert(i != none, message: name + " is missing from post-chain (dressing.typ)")
  html.nav(class: "post-nav", {
    if i > 0 {
      let (stem, title) = post-chain.at(i - 1)
      html.a(class: "prev", href: stem + ".html", {
        html.span(class: "post-nav-label", "← older")
        title
      })
    }
    if i < post-chain.len() - 1 {
      let (stem, title) = post-chain.at(i + 1)
      html.a(class: "next", href: stem + ".html", {
        html.span(class: "post-nav-label", "newer →")
        title
      })
    }
  })
}

#let post(
  category: "",
  date: none,
  tags: (),
  title: [],
  body,
) = html.article(class: "post", {
  html.header(class: "post-header", {
    html.p(class: "post-eyebrow", {
      html.span(class: "post-category", category)
      [ · ]
      html.time(datetime: date, date.display("[day] [month repr:long] [year]"))
    })
    html.h1(class: "post-title", title)
    html.ul(class: "tags", {
      for t in tags { html.li(t) }
    })
  })
  {
    // Typst's default highlighter inlines theme-blind colors; keep code in
    // the page's own palette instead. (Future: an everforest tmTheme.)
    set raw(theme: none)
    body
  }
})

// PDF-twin counterpart of post(): same metadata dict, paged styling that
// echoes the web faces. Pages spread one `meta` into both.
#let post-pdf(category: "", date: none, tags: (), title: [], body) = {
  set text(font: "Atkinson Hyperlegible", size: 11pt)
  show heading: set text(font: "Alegreya", weight: 500)
  show raw: set text(font: "Atkinson Hyperlegible Mono")

  text(font: "Alegreya", size: 20pt, weight: 500, title)

  v(0.5em)
  text(fill: luma(35%), {
    category
    [ · ]
    date.display("[day] [month repr:long] [year]")
    [ · ]
    tags.join(" · ")
  })
  v(1em)

  body
}

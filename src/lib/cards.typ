// Landing-page building blocks: project cards (hover preview + <details>
// touch fallback) and article rows. The markup mirrors
// design/mockup/index.html exactly — layout.css is written against it.

#let _badge(badge) = html.p(
  class: "badges",
  html.span(class: "badge " + badge.at(0), badge.at(1)),
)

#let _links(links) = html.p(class: "blurb-links", {
  for (label, href) in links {
    html.a(href: href, [#label ↗])
    [ ]
  }
})

// The whole card links to `href` (overlay anchor, m4xc-style); the real
// links inside sit above it via z-index. The hover preview carries its own
// full-surface link so the deployed card stays clickable.
#let project-card(
  title: [],
  href: "",
  thumb: "",
  badge: ("open", "open source"),
  tags: (),
  one-liner: [],
  blurb: [],
  links: (),
) = html.article(class: "project", {
  html.div(class: "thumb " + thumb)
  html.div(class: "card-body", {
    html.h3(html.a(href: href, title))
    html.p(one-liner)
    html.ul(class: "tags", {
      for t in tags { html.li(t) }
    })
    html.details(class: "more", {
      html.summary("details")
      html.div(class: "blurb", {
        _badge(badge)
        html.p(blurb)
        _links(links)
      })
    })
  })
  html.a(class: "card-link", href: href, aria-hidden: true, tabindex: -1)
  html.div(class: "preview", aria-hidden: true, {
    html.a(class: "preview-link", href: href, aria-hidden: true, tabindex: -1)
    html.div(class: "preview-thumb " + thumb)
    html.div(class: "preview-body", {
      html.h3(title)
      _badge(badge)
      html.p(blurb)
      _links(links)
    })
  })
})

// Deliberately plainer than the cards; the whole row links to `href`.
#let article-row(title: [], href: "", desc: [], date: none) = html.li({
  html.a(href: href, title)
  html.p(desc)
  html.time(datetime: date, date.display("[year]-[month]-[day]"))
  html.a(class: "row-link", href: href, aria-hidden: true, tabindex: -1)
})

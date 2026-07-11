// Webpage skeleton: the shared HTML chrome every page is staged inside.
// Pages call `webpage(path, title: ..)[content]` and get the sidebar
// (desktop) / collapsible header menu (mobile) and colophon for free.
//
// Pages may live in subdirectories (posts/*.html): webpage() derives a
// root prefix from the path so the chrome's asset references still
// resolve. Label destinations need no prefix — the bundle export computes
// relative hrefs itself.

#import "dressing.typ": site-name, nav-main, nav-groups, logo

#let head-stuff(root) = {
  // Site ships its own dark theme; tells Dark Reader to leave it alone
  // (also avoids its first-load background flash). Typst can only emit
  // into <body>, but Dark Reader's lock check is document-wide.
  html.meta(name: "darkreader-lock")
  html.link(rel: "icon", type: "image/jpeg", href: root + "img/logo.jpg")
  html.link(rel: "stylesheet", href: root + "layout.css")
  html.link(rel: "stylesheet", href: root + "theme.css")
}

#let brand(root) = html.a(class: "brand", href: root + "index.html", {
  logo(root)
  html.span(class: "brand-name", site-name)
})

// Label destinations go through native link() so the bundle export
// resolves them; URL strings become plain anchors.
#let nav-link(text, dest) = if type(dest) == label {
  link(dest, text)
} else {
  html.a(href: dest, text)
}

#let nav = html.nav(class: "site-nav", {
  html.ul(class: "nav-main", {
    for (text, dest) in nav-main {
      html.li(nav-link(text, dest))
    }
  })
  for (group, links) in nav-groups {
    html.div(class: "nav-group", {
      html.p(class: "nav-group-title", group)
      html.ul({
        for (text, dest) in links {
          html.li(nav-link(text, dest))
        }
      })
    })
  }
})

#let sidebar(root) = html.aside(class: "sidebar", {
  brand(root)
  nav
})

// Mobile replacement for the sidebar: centered brand + collapsible menu.
#let mobile-header(root) = html.header(class: "mobile-header", {
  brand(root)
  html.details({
    html.summary("menu")
    nav
  })
})

#let colophon = html.footer(class: "colophon", html.p({
  [© #site-name · built with ]
  html.a(href: "https://typst.app/", "typst")
  [ · ]
  html.a(href: "https://github.com/ldjennings/website", "source")
}))

#let webpage(path, title: none, body) = {
  let root = "../" * (path.split("/").len() - 1)
  document(path, title: title, {
    head-stuff(root)
    sidebar(root)
    html.div(class: "page", {
      mobile-header(root)
      html.main({
        body
        colophon
      })
    })
  })
}

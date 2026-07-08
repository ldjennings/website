// Webpage skeleton: the shared HTML chrome every page is staged inside.
// Pages call `webpage(path, title: ..)[content]` and get the sidebar
// (desktop) / collapsible header menu (mobile) for free.

#import "dressing.typ": site-name, nav-main, nav-groups, logo

#let head-stuff = {
  html.elem("link", attrs: (rel: "stylesheet", href: "main.css"))
  html.elem("link", attrs: (rel: "icon", href: "favicon.ico"))
}

#let brand = html.elem("a", attrs: (class: "brand", href: "index.html"), {
  logo
  html.elem("span", attrs: (class: "brand-name"), site-name)
})

#let nav = html.elem("nav", attrs: (class: "site-nav"), {
  html.elem("ul", attrs: (class: "nav-main"), {
    for (label, href) in nav-main {
      html.elem("li", html.elem("a", attrs: (href: href), label))
    }
  })
  for (group, links) in nav-groups {
    html.elem("div", attrs: (class: "nav-group"), {
      html.elem("p", attrs: (class: "nav-group-title"), group)
      html.elem("ul", {
        for (label, href) in links {
          html.elem("li", html.elem("a", attrs: (href: href), label))
        }
      })
    })
  }
})

#let sidebar = html.elem("aside", attrs: (class: "sidebar"), {
  brand
  nav
})

// Mobile replacement for the sidebar: centered brand + collapsible menu.
#let mobile-header = html.elem("header", attrs: (class: "mobile-header"), {
  brand
  html.elem("details", {
    html.elem("summary", "menu")
    nav
  })
})

#let webpage(path, title: none, body) = document(path, title: title, {
  head-stuff
  sidebar
  html.elem("div", attrs: (class: "page"), {
    mobile-header
    html.elem("main", body)
  })
})

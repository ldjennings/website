// Webpage skeleton: the shared HTML chrome every page is staged inside.
// Pages call `webpage(path, title: ..)[content]` and get the sidebar
// (desktop) / collapsible header menu (mobile) and colophon for free.
//
// Pages may live in subdirectories (posts/*.html): webpage() derives a
// root prefix from the path so the chrome's asset references still
// resolve. Label destinations need no prefix — the bundle export computes
// relative hrefs itself.

#import "dressing.typ": site-name, nav-main, nav-pages, nav-groups, logo

// Typst can only emit into <body>; the build moves these tags into <head>
// afterwards (tools/hoist-head.py), where the stylesheets block the first
// paint — otherwise Firefox flashes unstyled content on every navigation.
#let head-stuff(root) = {
  // Site ships its own dark theme; tells Dark Reader to leave it alone
  // (also avoids its first-load background flash).
  html.meta(name: "darkreader-lock")
  // Applied at parse time, before the stylesheets load — so the browser's
  // pre-CSS canvas is already dark in dark mode instead of flashing white
  // on every navigation. (theme.css declares color-scheme too, but that
  // only kicks in after the CSS arrives.)
  html.meta(name: "color-scheme", content: "light dark")
  // Tints the mobile browser toolbar to match the page background
  // (values mirror --bg in theme.css).
  html.meta(name: "theme-color", media: "(prefers-color-scheme: light)", content: "#fdf6e3")
  html.meta(name: "theme-color", media: "(prefers-color-scheme: dark)", content: "#2d353b")
  html.link(rel: "icon", type: "image/jpeg", href: root + "img/logo.jpg")
  html.link(rel: "stylesheet", href: root + "layout.css")
  html.link(rel: "stylesheet", href: root + "theme.css")
}

#let brand(root) = html.a(class: "brand", href: root + "index.html", {
  logo(root)
  html.span(class: "brand-name", site-name)
})

// The page's <h1>: standalone pages carry one of these instead of the
// .post header (markup headings start at <h2> — see anchored() below).
#let page-title(body) = html.h1(class: "page-title", body)

// Label destinations go through native link() so the bundle export
// resolves them; URL strings become plain anchors.
#let nav-link(text, dest) = if type(dest) == label {
  link(dest, text)
} else {
  html.a(href: dest, text)
}

// ---- In-page navigation ----
// Every heading in the body gets an anchor id, and the nav gains an
// "on this page" group linking to them. The headings are collected by
// walking the body content directly — query() can't be used here: the
// bundle shares one introspection world, so it returns every document's
// headings, not just this page's.

// Plain text of (heading) content, for slugs.
#let plain(it) = {
  if type(it) == str { it }
  else if type(it) != content { repr(it) }
  else if it.has("text") { it.text }
  else if it.has("children") { it.children.map(plain).join() }
  else if it.has("child") { plain(it.child) }
  else if it.has("body") { plain(it.body) }
  else if repr(it.func()) == "space" { " " }
  else { "" }
}

#let slug(it) = lower(plain(it)).replace(regex("[^a-z0-9]+"), "-").trim("-")

// A heading's anchor: its explicit label if it has one (so label links
// from other pages keep resolving), else a slug of its text.
#let heading-id(h) = if h.at("label", default: none) != none { str(h.label) } else { slug(h.body) }

#let collect-headings(it) = {
  if type(it) != content { () }
  else if it.func() == heading { (it,) }
  else {
    let inner = if it.has("children") { it.children }
      else if it.has("body") { (it.body,) }
      else if it.has("child") { (it.child,) }
      else { () }
    inner.map(collect-headings).sum(default: ())
  }
}

// Markup headings carry `depth` (resolved ones `level`); either way,
// depth n renders as an <h(n+1)> — h1 is the post title.
#let heading-depth(h) = h.at("depth", default: h.at("level", default: 1))

// The "on this page" nav group: top-level sections with their
// sub-sections nested under them; none when the page has no headings.
// A <details> like the Projects sub-list, but starts expanded — the
// current page's sections are the most immediately useful links.
#let toc-group(body) = {
  let groups = ()
  for h in collect-headings(body) {
    if heading-depth(h) <= 1 or groups.len() == 0 {
      groups.push((h, ()))
    } else {
      let (top, subs) = groups.last()
      groups.at(groups.len() - 1) = (top, subs + (h,))
    }
  }
  if groups.len() == 0 { return none }
  html.details(class: "nav-group page-toc", open: true, {
    html.summary(class: "nav-group-title", "On this page")
    html.ul({
      for (top, subs) in groups {
        html.li({
          html.a(href: "#" + heading-id(top), top.body)
          if subs.len() > 0 {
            html.ul({
              for s in subs {
                html.li(html.a(href: "#" + heading-id(s), s.body))
              }
            })
          }
        })
      }
    })
  })
}

// Renders headings as html elements carrying the anchor ids the TOC
// links to (the native export only emits ids for labeled headings).
#let anchored(body) = {
  show heading: it => html.elem(
    "h" + str(it.level + 1),
    attrs: (id: heading-id(it)),
    it.body,
  )
  body
}

// Entries with a sub-list become a <details>: the summary holds the real
// link (clicking it navigates) plus a CSS caret that toggles the list.
#let nav(toc) = html.nav(class: "site-nav", {
  html.ul(class: "nav-main", {
    for entry in nav-main {
      let (text, dest) = (entry.at(0), entry.at(1))
      let sub = entry.at(2, default: none)
      if sub == none {
        html.li(nav-link(text, dest))
      } else {
        html.li(html.details(class: "nav-expand", {
          html.summary(nav-link(text, dest))
          html.ul(class: "nav-sub", {
            for (text, dest) in sub {
              html.li(nav-link(text, dest))
            }
          })
        }))
      }
    }
  })
  html.ul(class: "nav-pages", {
    for (text, dest) in nav-pages {
      html.li(nav-link(text, dest))
    }
  })
  if toc != none { toc }
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

#let sidebar(root, toc) = html.aside(class: "sidebar", {
  brand(root)
  nav(toc)
})

// Mobile replacement for the sidebar: centered brand + collapsible menu.
#let mobile-header(root, toc) = html.header(class: "mobile-header", {
  brand(root)
  html.details({
    html.summary("menu")
    nav(toc)
  })
})

#let colophon = html.footer(class: "colophon", html.p({
  [© #site-name · built with ]
  html.a(href: "https://typst.app/", "typst")
  [ · ]
  html.a(href: "https://github.com/ldjennings/website", "source")
}))

// Scripts for pages embedding 3D models (post.typ's fig3d): the config
// global must exist before the component script reads it — it names the
// decoder for the meshopt-compressed .glb files, which the component
// only fetches when a model actually needs it. The click listener is
// the tap-to-load: model-viewer 4 dropped reveal="interaction", so
// manual-reveal posters only dismiss through dismissPoster(). The module
// script defers itself; both land in <body> (hoist-head only moves
// meta/link/base) and nothing on the page depends on them — no-JS
// readers get fig3d's poster.
#let viewer-scripts(root) = {
  html.script(
    "self.ModelViewerElement = { meshoptDecoderLocation: "
      + repr(root + "js/meshopt_decoder.js") + " };\n"
      + "document.addEventListener('click', (e) => {\n"
      + "  const mv = e.target.closest && e.target.closest('model-viewer[reveal=manual]');\n"
      + "  if (mv && !mv.loaded) mv.dismissPoster();\n"
      + "});",
  )
  html.script(type: "module", src: root + "js/model-viewer.min.js", "")
}

// base: set to "/" for pages served at arbitrary URLs (the 404 page) —
// emits a <base> so every relative href resolves from the site root
// instead of the requested path (hoist-head.py moves it into <head>).
// toc: pages with headings get an "on this page" nav group linking to
// them, with the headings anchored to match (see the in-page navigation
// block above); headingless pages are unaffected. toc: false opts out —
// the index, whose sections nav-main already lists.
// viewer: opt-in for pages with fig3d models — loads the (self-hosted)
// model-viewer component; other pages never pay for the script.
#let webpage(path, title: none, base: none, toc: true, viewer: false, body) = {
  let root = if base == none { "../" * (path.split("/").len() - 1) } else { "" }
  let toc = if toc { toc-group(body) } else { none }
  document(path, title: title, {
    if base != none { html.base(href: base) }
    head-stuff(root)
    if viewer { viewer-scripts(root) }
    sidebar(root, toc)
    html.div(class: "page", {
      mobile-header(root, toc)
      html.main({
        if toc != none { anchored(body) } else { body }
        colophon
      })
    })
  })
}

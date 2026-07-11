#import "../lib/skeleton.typ": webpage

// GitHub Pages serves 404.html for any missing URL, at whatever path was
// requested — hence base: "/" so the chrome's relative hrefs still resolve.
#webpage("404.html", title: [404], base: "/")[
  #html.h1(class: "page-title")[404]

  Sorry, but the page could not be found. Head back
  #link(<home>)[home]?
]

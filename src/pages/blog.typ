#import "../lib/skeleton.typ": webpage

#webpage("blog.html", title: [Blog])[
  #title()
  Welcome to my blog!
  $ "abc" = 123 $

  $ sum^n_i $

  ...

  This blog also exists as a
  #link(<blog-pdf>)[single PDF].
] <blog>

// PDF twin of the blog page — plain #document, no HTML chrome.
#document("blog.pdf", title: [Blog])[
  ...
] <blog-pdf>

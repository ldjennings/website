#import "../lib/skeleton.typ": webpage

#webpage("blog.html", title: [Blog])[
  #title()
  Welcome to my blog!
  $ "abc" = 123 $

  $ sum^n_i $

  ...

  This blog also exists as a
  #link(<blog-pdf>)[single PDF].


  The quick brown fox jumps over the lazy dog.

  
  #set text(font: "Junicode")
  The quick brown fox jumps over the lazy dog.
] <blog>

// PDF twin of the blog page — plain #document, no HTML chrome.
// Junicode comes from the flake's pinned font set, not the host system.
#document("blog.pdf", title: [Blog])[
  The quick brown fox jumps over the lazy dog.


  #set text(font: "Junicode")
  The quick brown fox jumps over the lazy dog.

  ...
] <blog-pdf>

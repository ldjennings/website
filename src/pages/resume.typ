#import "../lib/skeleton.typ": webpage
#import "../lib/post.typ": btn

// The sheet and the PDF come from the resume flake input (see flake.nix);
// this page just frames them in the site chrome. An HTML-text edition was
// tried and rejected — the typeset sheet looks better.
#webpage("resume.html", title: [Resume — Liam Jennings])[
  #html.h1(class: "page-title")[Resume]

  #btn(([Download as PDF ↓], "resume.pdf"))

  #html.img(
    class: "resume-sheet",
    src: "resume.svg",
    alt: "Liam Jennings' resume: software and robotics engineer",
  )
] <resume>

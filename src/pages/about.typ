#import "../lib/skeleton.typ": webpage, page-title
#import "../lib/post.typ": btn

// Bio carried over from the previous site's homepage.
#webpage("about.html", title: [About])[
  #page-title[About]

  My work focuses on embedded systems, real-time controls, and hardware
  validation. I have hands-on experience with STM32 firmware development,
  CAN bus communication, and hardware-in-the-loop testing. I completed my
  B.S. in Computer Science at WPI in 2025; most recently, I worked as a
  Hardware Test Engineer at #link("https://www.symbotic.com/")[Symbotic],
  where I designed test fixtures and built automated tooling for embedded
  system validation.

  I'm motivated by the pride of making something well. Engineering is an
  art to me. I constantly see systems that were never quite finished,
  awkward to use, and painful to maintain. I want to do better. Making
  the world around me a little smoother, a little more reliable, a little
  more considerate of the people who have to live with it — that makes me
  genuinely happy.

  That said, craftsmanship takes time, and most problems don't need it.
  Knowing where it should be applied is usually more important than the
  craftsmanship itself. Getting something real and tangible across the
  finish line is equally motivating: there's satisfaction in seeing
  something ship, and something lost when it doesn't.

  I've learned to balance the two.

  #btn(([View my resume], "resume.html"))
] <about>

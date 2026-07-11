#import "../../lib/skeleton.typ": webpage
#import "../../lib/post.typ": post, btn, post-nav

#let meta = (
  category: "robotics",
  date: datetime(year: 2026, month: 5, day: 1),
  tags: ("python", "planning"),
  title: [RBE 550 Motion Planning Reports],
)

#webpage("posts/motion-planning.html", title: meta.title)[
  #post(..meta)[
    = overview

    For RBE 550 (Motion Planning) at WPI, I completed three major projects
    exploring different aspects of motion planning algorithms. I took the
    opportunity to go overboard with the technical reports, focusing on
    clear explanations and thorough documentation.

    = project reports

    == Valet: Hybrid A\* for multiple vehicle types

    Implemented Hybrid A\* search for four vehicle models of increasing
    complexity: holonomic point robot, differential drive, Ackermann car,
    and car with trailer. Includes collision detection optimizations and
    Reeds-Shepp path connections.

    #btn(([Download report ↓], "../docs/valet.pdf"))

    == Wildfire: discrete vs sampling-based planning

    A competitive simulation between two agents: a grid-based "Wumpus"
    using A\* to ignite obstacles, and a firetruck using a PRM with
    Reeds-Shepp local connections to pursue and extinguish fires.

    #btn(([Download report ↓], "../docs/wildfire.pdf"))

    == Transmission: BiRRT for disassembly planning

    Used Bidirectional RRT to plan a collision-free removal path for the
    mainshaft of an SM-465 manual transmission, navigating around the
    countershaft and enclosure geometry.

    #btn(([Download report ↓], "../docs/transmission.pdf"))

    = what i learned

    These projects gave me practice implementing and comparing different
    planning algorithms — from basic graph search to RRTs and
    optimization-based methods. Writing detailed reports forced me to
    really understand the tradeoffs between approaches and communicate
    them clearly.

    #post-nav(
      prev: ([symbotic co-op], "symbotic.html"),
    )
  ]
] <motion-planning>

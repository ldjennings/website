#import "../../lib/skeleton.typ": webpage
#import "../../lib/post.typ": post, post-nav

#let meta = (
  category: "work",
  date: datetime(year: 2025, month: 12, day: 15),
  tags: ("embedded", "test"),
  title: [Hardware Test Engineering Co-op at Symbotic],
)

#webpage("posts/symbotic.html", title: meta.title)[
  #post(..meta)[
    = overview

    From July to December 2025, I worked as a Hardware Test Engineering
    Co-op at #link("https://www.symbotic.com/")[Symbotic] in Boston.
    Symbotic builds autonomous warehouse robotics systems for large-scale
    logistics operations.

    = what i did

    I owned end-to-end execution of hardware validation tests for
    embedded and electromechanical subsystems — developing test
    procedures, running tests, and documenting failure criteria and
    results to support team-level verification and validation efforts.

    Key projects included:

    - *HIL test fixture redesign*: redesigned a hardware-in-the-loop
      traction motor test fixture with closed-loop PID control and
      MQTT-over-Ethernet communication to support reliable multi-month
      accelerated life testing.
    - *Automated tooling*: built Python tools for log parsing and
      time-series visualization using InfluxDB. Maintained tooling under
      Git with unit tests and CI/CD pipelines.
    - *Hardware debugging*: diagnosed hardware faults and characterized
      subsystem behavior using oscilloscopes and embedded
      instrumentation.

    = what i learned

    This role gave me experience working on hardware validation at
    scale — where test reliability and documentation matter as much as
    the test results themselves. Building tooling that other engineers
    depend on reinforced the importance of writing maintainable code with
    proper tests and version control, even for internal tools.

    #post-nav(
      prev: ([formula electric], "formula-electric.html"),
      next: ([motion planning], "motion-planning.html"),
    )
  ]
] <symbotic>

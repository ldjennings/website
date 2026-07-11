#import "../lib/skeleton.typ": webpage
#import "../lib/cards.typ": project-card, article-row

// Write-up pages, all local under posts/.
#let up = (
  motion: "posts/motion-planning.html",
  symbotic: "posts/symbotic.html",
  formula: "posts/formula-electric.html",
  quad: "posts/quadrotor.html",
  arm: "posts/robot-arm.html",
  romi: "posts/maze-robot.html",
  rl: "posts/reinforcement-learning.html",
  derain: "posts/deraining.html",
)

#let projects = (
  (
    title: [motion planning],
    href: up.motion,
    thumb: "thumb-motion",
    badge: ("study", "coursework"),
    tags: ("python", "planning"),
    one-liner: [Hybrid A\*, PRM pursuit, and trajectory planning across
      three graduate projects, each with a full technical report.],
    blurb: [Three projects from RBE 550 at WPI: Hybrid A\* search for four
      vehicle models — from a holonomic point robot up to a car with
      trailer — with Reeds-Shepp connections; and a pursuit simulation
      pitting a grid-based A\* agent against a firetruck planning over a
      PRM. Reports written to actually explain the algorithms, not just
      log results.],
    links: (("write-up", up.motion), ("source", "https://github.com/ldjennings/valet")),
  ),
  (
    title: [symbotic co-op],
    href: up.symbotic,
    thumb: "thumb-sym",
    badge: ("lab", "industry"),
    tags: ("embedded", "test"),
    one-liner: [Hardware test engineering for autonomous warehouse
      robotics: HIL fixtures, validation, and automated tooling.],
    blurb: [Owned end-to-end hardware validation for embedded and
      electromechanical subsystems. Redesigned a hardware-in-the-loop
      traction motor fixture with closed-loop PID and MQTT-over-Ethernet
      for multi-month accelerated life testing, and built Python tooling
      for log parsing and time-series visualization with InfluxDB.],
    links: (("write-up", up.symbotic),),
  ),
  (
    title: [formula electric],
    href: up.formula,
    thumb: "thumb-formula",
    badge: ("open", "open source"),
    tags: ("stm32", "can", "pcb"),
    one-liner: [Embedded electronics for WPI's competition EV: the
      inverter controller and a driver radio telemetry board.],
    blurb: [Designed and validated boards for the 2024–25 car: an STM32
      mixed-signal inverter controller that conditions pedal inputs and
      commands the motor controller over CAN, and a Bluetooth driver-radio
      board for live telemetry — PCB design through firmware and vehicle
      integration.],
    links: (
      ("write-up", up.formula),
      ("source", "https://github.com/ldjennings/driver-radio"),
    ),
  ),
  (
    title: [quadrotor interception],
    href: up.quad,
    thumb: "thumb-quad",
    badge: ("study", "coursework"),
    tags: ("matlab", "controls"),
    one-liner: [Sliding mode control for a quadrotor autonomously chasing
      down an intruding UAV in simulation.],
    blurb: [A sliding mode controller regulating altitude, roll, and
      pitch, paired with trajectory prediction of the target, so the
      quadrotor can track, intercept, and return with an intruder inside a
      10 m bounded airspace — staying stable through the disturbance of
      capture.],
    links: (("write-up", up.quad), ("source", "https://github.com/ldjennings/RBE502Quadrotor")),
  ),
  (
    title: [3-dof robot arm],
    href: up.arm,
    thumb: "thumb-arm",
    badge: ("study", "coursework"),
    tags: ("robotics", "cad"),
    one-liner: [A planar arm designed, analyzed, and actually fabricated
      to move a 500 g payload between poses.],
    blurb: [Full-stack arm design for RBE 501: forward kinematics via the
      Product of Exponentials, closed-form geometric inverse kinematics,
      trajectory generation, dynamics analysis, and motor selection. The
      course only required the analysis — we built the physical arm
      anyway.],
    links: (("write-up", up.arm),),
  ),
  (
    title: [single image deraining],
    href: up.derain,
    thumb: "thumb-derain",
    badge: ("open", "open source"),
    tags: ("python", "deep learning"),
    one-liner: [A convolutional variational autoencoder that removes
      raindrop blur from photographs.],
    blurb: [A CVAE trained to reconstruct clean images from rain-degraded
      inputs, built as a machine learning course final project. The
      write-up walks through the architecture, the DeRaindrop dataset,
      and an honest look at where the reconstructions fell short.],
    links: (
      ("write-up", up.derain),
      ("source", "https://github.com/ldjennings/deraining-tools"),
    ),
  ),
)

#let articles = (
  (
    title: [Hybrid A\* for four vehicle types],
    href: up.motion,
    desc: [From a holonomic point robot to a car with a trailer — how the
      same search adapts as the kinematics get harder.],
    date: datetime(year: 2026, month: 5, day: 1),
  ),
  (
    title: [Rebuilding a HIL fixture for months-long life testing],
    href: up.symbotic,
    desc: [Closed-loop PID, MQTT over Ethernet, and what it takes to keep
      an accelerated life test honest.],
    date: datetime(year: 2025, month: 12, day: 15),
  ),
  (
    title: [Reinforcement learning in ROS],
    href: up.rl,
    desc: [Teaching a simulated TurtleBot to push a cylinder to a goal in
      Gazebo — and what the reward function got wrong first.],
    date: datetime(year: 2022, month: 12, day: 16),
  ),
  (
    title: [Maze-solving ROMI robots],
    href: up.romi,
    desc: [Rangefinders, encoder kinematics, and an OpenMV camera,
      combined to navigate a random maze autonomously.],
    date: datetime(year: 2022, month: 12, day: 13),
  ),
)

#webpage("index.html", title: [Liam Jennings])[
  #html.h1(class: "page-title")[
    Robotics Engineer #html.span(class: "title-sep")[|] Embedded Systems & Software
  ]
  #html.p(class: "intro")[I'm Liam — based in Seattle, currently pursuing
    my Master's in Robotics Engineering at WPI. I work on embedded
    systems, real-time controls, and hardware validation — and I like
    making things well.]

  = projects <projects>

  #html.div(class: "project-grid")[
    #for p in projects { project-card(..p) }
  ]

  = writing <writing>

  #html.ul(class: "article-list")[
    #for a in articles { article-row(..a) }
  ]
] <home>

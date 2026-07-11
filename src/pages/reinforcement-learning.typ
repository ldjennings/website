#import "../lib/skeleton.typ": webpage
#import "../lib/post.typ": post, btn, video, post-nav

#let meta = (
  category: "robotics",
  date: datetime(year: 2022, month: 12, day: 16),
  tags: ("ros", "machine learning"),
  title: [Reinforcement Learning in ROS],
)

#webpage("reinforcement-learning.html", title: meta.title)[
  #post(..meta)[
    = overview

    For our end-of-semester project in the Artificial Intelligence class,
    my group and I found ourselves gravitating towards the field of
    reinforcement learning, a domain that aligned well with our studies
    in robotics.

    = problem

    While intrigued by the practical applications of reinforcement
    learning in robotics, we faced the potential hurdle of time and
    resource constraints that could arise from building a physical robot
    from scratch. Moreover, we wanted to maintain a focus on exploring
    the algorithmic aspects of artificial intelligence within the scope
    of the project.

    = solution

    Opting for a practical and time-efficient approach, we decided to
    work with ROS's Gazebo simulator and the TurtleBot library to
    simulate our robot's environment. In our simulation, the robot's
    objective was to push a cylinder to a random goal area within a
    designated space, a task during which it had to avoid wall collisions
    to prevent heavy penalties. We utilized a deep Q-learning algorithm
    to control the robot's actions, training it to navigate towards the
    goal effectively.

    You can see the robot's training phase in this sped-up video:

    #video("sYeYrgIsD40", [Deep Q-learning training run, sped up])

    #btn(
      ([Report ↓], "docs/rl-report.pdf"),
      ([Explore the codebase ↓], "docs/rl-code.zip"),
    )

    = what i learned

    This project was a nice dip into the world of artificial intelligence
    and reinforcement learning. Utilizing a simulation instead of a
    physical robot allowed us to streamline the project, helping us save
    time and focus more on the algorithmic aspects. The task gave us a
    preliminary insight into the practical applications of what we'd
    learned in class, offering a firsthand glimpse into the hiccups and
    considerations of working on a simulation project like this one — a
    good starting point for future projects applying reinforcement
    learning in a robotics context.

    #post-nav(
      prev: ([maze-solving romis], "maze-robot.html"),
      next: ([3-dof robot arm], "robot-arm.html"),
    )
  ]
] <reinforcement-learning>

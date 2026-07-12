#import "../../lib/skeleton.typ": webpage
#import "../../lib/post.typ": post, fig, btn, video, post-nav

#let meta = (
  category: "robotics",
  date: datetime(year: 2022, month: 12, day: 13),
  tags: ("c++", "embedded"),
  title: [Maze-Solving ROMI Robots],
)

#webpage("posts/maze-robot.html", title: meta.title)[
  #post(..meta)[
    = Overview

    During our time in the "Unified Robotics: Sensing" course, we worked
    closely with Pololu ROMI robots, featuring Atmega32U4 embedded
    control boards, to delve deep into the field of robotic sensing. The
    curriculum introduced us to a range of sensing techniques through
    hands-on labs, incorporating elements such as rangefinders, encoder
    ticks for kinematics, pitch detection through complementary filters,
    and computer vision enabled by an OpenMV camera.

    #fig("romi.jpg", [One of our ROMIs], alt: "Photo of a ROMI robot")

    = Problem

    As we approached our final project, we were met with the challenging
    task of combining all that we had learned to enable our robots to
    autonomously navigate a random maze. All members of our team, in
    addition to being Robotics majors, were Computer Science majors as
    well, so we decided to go above and beyond — aiming to fulfill
    numerous bonus objectives and develop a robust codebase. We quickly
    encountered a hurdle: the Atmega board's memory limitations,
    exacerbated by our extensive codebase filled with debug statements,
    became a substantial barrier to housing our ambitious project.

    = Solution

    To circumvent the memory issue, we devised a strategy to shift the
    higher-level logic to the ESP-32, maintaining communication with the
    Atmega board through a serial connection. A team member facilitated
    this transition by developing a small RPC library. With the
    foundation firm, we then focused on networking the robots through
    serial-connected ESP-32 boards linked to an MQTT server, allowing for
    effective coordination during the maze navigation.

    In the end, our effort was captured in a demonstration video
    showcasing our ROMIs' autonomous maze navigation — mapping the maze
    as a bonus objective:

    #video("Xb8Sdb8YRmQ", [Autonomous maze navigation demo])

    #btn(([Explore the codebase ↓], "../docs/romi-code.zip"))

    = What I Learned

    This project was an enriching learning experience that extended
    beyond just robotics. We navigated challenges tied to resource
    optimization and networking, gaining a deeper appreciation for the
    collaborative spirit of problem-solving. I learned numerous ways to
    interpret, combine, and apply sensors to achieve various goals. It
    also provided a practical scenario where we learned to balance
    ambition with feasibility, steering our project to a successful
    completion.

    #post-nav("maze-robot")
  ]
] <maze-robot>

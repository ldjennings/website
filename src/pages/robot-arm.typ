#import "../lib/skeleton.typ": webpage
#import "../lib/post.typ": post, fig, btn, post-nav

#let meta = (
  category: "robotics",
  date: datetime(year: 2023, month: 12, day: 3),
  tags: ("robotics", "cad"),
  title: [3-DOF Robot Arm Design and Fabrication],
)

#webpage("robot-arm.html", title: meta.title)[
  #post(..meta)[
    = overview

    For RBE 501 (Robot Dynamics) at WPI, our team designed a 3-DOF planar
    robot arm capable of moving a 500 g payload between three defined
    positions. The course project required kinematic analysis, CAD
    modeling, trajectory generation, dynamics analysis, and motor
    selection — but we chose to go further and physically fabricate the
    arm as well.

    #fig("real-arm.jpg", [The completed robot arm with 500 g steel payload],
      alt: "Photo of the fabricated robot arm")

    #fig("arm_home_pose.png", [CAD model in home configuration (left) and Pose 1 (right)],
      alt: "CAD renders of the arm in two configurations")

    = kinematic design

    We designed a planar arm with link lengths of 10 cm, 10 cm, and 5 cm.
    Forward kinematics were computed using the Product of Exponentials
    (PoE) formulation, while inverse kinematics used a geometric approach
    with the Law of Cosines and Law of Sines to find closed-form
    solutions for each target pose.

    #fig("arm_dims.png", [Link lengths and workspace sketch],
      alt: "Dimensioned sketch of the arm's links and workspace")

    = trajectory generation

    Smooth trajectories were generated using quintic polynomials in joint
    space. The polynomial coefficients were computed to satisfy
    constraints on position, velocity, and acceleration at the start and
    end of each motion segment — ensuring zero velocity and acceleration
    at rest positions.

    = dynamics and motor selection

    We analyzed joint torques using the Recursive Newton-Euler (RNE)
    algorithm, computing both gravity compensation and inertial torques
    at each timestep. Based on the maximum torque, velocity, and
    acceleration requirements, we selected Hiwonder HTD-45H servo motors,
    which provided a safety factor of approximately 5.5× on torque.

    #fig("arm_dynamics.png", [Joint torques throughout the trajectory],
      alt: "Plot of joint torques over time")

    = what i learned

    This project gave me hands-on experience connecting theoretical
    robotics concepts to physical hardware. Deriving kinematics and
    dynamics by hand, then validating them against a real system,
    reinforced how small modeling assumptions affect real-world behavior.
    It also highlighted the value of doing rough calculations early — we
    estimated motor requirements before completing the full analysis,
    which let us start fabrication in parallel.

    #btn(([View full report ↓], "docs/robot-arm-report.pdf"))

    #post-nav(
      prev: ([reinforcement learning in ros], "reinforcement-learning.html"),
      next: ([quadrotor interception], "quadrotor.html"),
    )
  ]
] <robot-arm>

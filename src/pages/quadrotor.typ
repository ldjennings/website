#import "../lib/skeleton.typ": webpage
#import "../lib/post.typ": post, fig, btn, post-nav

#let meta = (
  category: "robotics",
  date: datetime(year: 2023, month: 12, day: 13),
  tags: ("matlab", "controls"),
  title: [Intercepting a Simulated UAV with a Quadrotor Using Sliding Mode Control],
)

#webpage("quadrotor.html", title: meta.title)[
  #post(..meta)[
    = overview

    As part of the "Nonlinear Control of Robotic Systems" course at WPI,
    our team developed and simulated a quadrotor control system capable
    of autonomously intercepting a UAV within a bounded airspace. We
    designed a Sliding Mode Controller (SMC) to regulate the quadrotor's
    altitude, roll, and pitch, while predicting the UAV's future
    trajectory to improve interception accuracy.

    #fig("real-quad.png", [Problem setup], alt: "Diagram of the interception problem")

    = problem

    The challenge was to ensure a quadrotor could track, intercept, and
    return with an intruding UAV in a 10×10×10 m airspace. The vehicle
    had to autonomously detect the target's position, predict its motion,
    and perform interception while maintaining stability even under
    disturbances introduced during capture.

    To meet this goal, we restricted yaw control and focused on the
    remaining three axes. The underactuated nature of the quadrotor made
    the control problem particularly interesting — we could only directly
    control four of the six degrees of freedom.

    = solution

    We modeled the quadrotor dynamics and derived individual SMC laws for
    altitude and orientation control. Sliding Mode Control was chosen for
    its robustness against modeling uncertainties and disturbances. The
    control law was divided into two components:

    - Sliding phase, ensuring stable convergence, and
    - Reaching phase, managing the approach to the sliding surface while
      mitigating chattering.

    To guide the quadrotor toward the UAV, we implemented trajectory
    prediction using a simple numerical approach: fitting a parabola
    through recent UAV positions to estimate future velocity and
    acceleration. The quadrotor then used these predicted states as
    targets for interception.

    A state machine managed the mission flow:

    - Follow UAV — track the predicted path
    - Capture — close in within 0.1 m
    - Stabilize — maintain steady hover after capture
    - Return — navigate back to the home nest

    The simulation validated successful interception and return
    behavior, with clear trajectory tracking and stable performance prior
    to the capture disturbance phase.

    #fig("quadrotor_result.png", [Quadrotor (green) intercepting a UAV (blue)],
      alt: "3D plot of the interception trajectories")

    = what i learned

    This project deepened my understanding of nonlinear control systems,
    especially in handling underactuated aerial vehicles. Designing the
    SMC and trajectory prediction taught me how small modeling and tuning
    details can significantly affect system stability. While the
    simulation succeeded in interception, it also highlighted how
    difficult it is to maintain post-capture stability — an area I'd like
    to explore further through improved tuning and disturbance rejection
    strategies.

    #btn(([View on GitHub ↗], "https://github.com/ldjennings/RBE502Quadrotor"))

    #post-nav(
      prev: ([3-dof robot arm], "robot-arm.html"),
      next: ([formula electric], "formula-electric.html"),
    )
  ]
] <quadrotor>

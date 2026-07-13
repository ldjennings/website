#import "../../lib/skeleton.typ": webpage
#import "../../lib/post.typ": post, fig, btn, post-nav

// Adapted from the full technical report (assets/docs/wildfire.pdf),
// which additionally covers setup, dependencies, and the table of
// assumptions filled in where the assignment spec was ambiguous.
#let meta = (
  category: "motion planning",
  date: datetime(year: 2026, month: 5, day: 1),
  tags: ("python", "planning"),
  title: [Wildfire: Grid A\* vs. PRM in a Pursuit Game],
)

#webpage("posts/wildfire.html", title: meta.title)[
  #post(..meta)[
    A competitive simulation between two planners. The "Wumpus" — a
    grid-based arsonist — walks an obstacle field igniting tetrominoes,
    while a firetruck with Ackermann steering chases the fires down and
    extinguishes them. The Wumpus plans with discrete A\* on the grid;
    the truck plans over a Probabilistic Roadmap with Reeds-Shepp local
    connections. Five randomized 3600-second rounds decide a champion.
    Built for RBE 550 (Motion Planning) at WPI.

    #fig("wildfire_sim.png",
      [Mid-simulation: orange/red cells are burning, the firetruck
        (blue) is en route to the nearest fire, the Wumpus (red) is off
        lighting new ones. The PRM graph is drawn in the background.],
      alt: "Simulation frame showing a grid field with burning obstacles, a firetruck, the Wumpus, and a roadmap graph of nodes and edges")

    #btn(([Full report (PDF) ↓], "../docs/wildfire.pdf"))

    The Ackermann kinematics, Reeds-Shepp trajectory generation, and
    two-phase collision checker carried over from
    #link(<valet>)[the valet project]; the new work is the fire
    mechanics, the roadmap planner, and the two agents. Neither agent
    got a sophisticated high-level strategy on purpose — the point is
    the planners, not game theory.

    = Fire Mechanics

    The field is 250 m × 250 m in 5 m cells, seeded with tetromino
    obstacles until 10% of cells are occupied. Each obstacle runs a
    small state machine:

    #fig("wildfire_states.svg",
      [Obstacle states. Neither terminal state can be reignited.],
      alt: "State machine: Intact goes to Burning when ignited; Burning goes to Burned after 60 seconds or to Extinguished if the firetruck puts it out")

    Ten seconds after ignition, a Wumpus-lit obstacle spreads fire to
    everything intact within 30 m; obstacles lit by spread only creep to
    their immediate grid neighbors. (Unlimited chain reactions were
    tested first — lighting a single obstacle auto-won the game for the
    Wumpus via cascade, so the rule was reined in.) A burning obstacle
    burns out after 60 seconds if the truck doesn't get there first.

    = The Wumpus: Discrete A\*

    The Wumpus moves cell-to-cell and ignites obstacles adjacent to it,
    picking targets that trade off two objectives — far from the truck
    (so fires get time to spread) but not too far from itself:

    $ "score"(o) = d(p_"truck", o) - 0.5 dot d(p_"wumpus", o) $

    Navigation is textbook A\* on the 50 × 50 occupancy grid with
    8-connected moves and an octile-distance heuristic. Replanning
    happens whenever the target burns down on its own or the path runs
    out — and each replan costs so little it barely registers in the
    CPU budget.

    = The Firetruck: PRM

    The truck is a Mercedes Unimog — 4.9 m long, 13 m minimum turning
    radius, 10 m/s top speed — which makes its planning problem
    fundamentally continuous. It gets a Probabilistic Roadmap built once
    at simulation start: 500 collision-free poses sampled by rejection,
    each connected to its 15 nearest neighbors (via a KDTree) when a
    Reeds-Shepp trajectory between them under 50 m long clears all
    obstacles at 1 m resolution.

    A query then stitches: connect the start pose to the nearest
    reachable roadmap node, find an *escapable* goal pose — eight
    candidate headings are tried until one can connect back to the
    roadmap, so the truck never strands itself on arrival — run A\* over
    the graph, generate dense Reeds-Shepp trajectories per segment, and
    smooth the result with 200 rounds of probabilistic shortcutting.

    The escapability rule exists because unvalidated poses are traps:

    #fig("wildfire_truck_stuck.png",
      [The truck stopped at a pose with no collision-free Reeds-Shepp
        connection back to the roadmap — motionless for the rest of the
        run. The goal-pose escapability check prevents this; stopping
        mid-path to extinguish would reintroduce it, so the truck only
        extinguishes after arriving.],
      alt: "Simulation frame with the firetruck wedged near obstacles, disconnected from the roadmap graph")

    A rarer failure is the start pose itself being geometrically
    isolated from every sampled node — then the truck simply never
    moves:

    #fig("wildfire_stuck_start.png",
      [A seed where the truck's starting corner can't reach the roadmap
        at all.],
      alt: "Simulation frame where the firetruck's corner region is walled off from the rest of the field")

    = Results

    #table(
      columns: 7,
      stroke: none,
      table.header(
        [Run], [Seed], [Wumpus], [Truck], [Winner], [W-plan (s)], [T-plan (s)],
      ),
      [1], [3235666703], [264], [214], [Wumpus], [0.039], [2.809],
      [2], [3235666704], [246], [254], [Truck], [0.039], [3.581],
      [3], [3235666705], [236], [260], [Truck], [0.036], [2.790],
      [4], [3235666706], [222], [260], [Truck], [0.036], [3.356],
      [5], [3235666707], [276], [230], [Wumpus], [0.034], [2.831],
      [Total], [], [1244], [1218], [Truck 3–2], [0.184], [15.367],
    )

    The truck took the series 3–2, but the efficiency story runs the
    other way: 1218 points over 15.4 s of planning (~79 points per
    CPU-second) against the Wumpus's 1244 points over 0.18 s (~6900
    points per CPU-second). Grid A\* is orders of magnitude cheaper than
    building and querying a roadmap — the truck spends about a second up
    front on construction and another 1.5–2.5 s per run on queries.

    #fig("wildfire_cpu_times.png",
      [Cumulative planning CPU time per agent over all five runs.],
      alt: "Bar chart comparing total planning CPU time: the truck's PRM time towers over the Wumpus's A-star time")

    Each planner fits its constraints: the Wumpus's cell-by-cell motion
    is exactly what grid A\* models, and its paths are grid-optimal by
    construction. The truck can't turn tighter than 13 m, so only a
    planner with kinematically-correct local connections produces paths
    it can actually follow — and its paths are suboptimal at several
    levels (sparse sampling, k-nearest connectivity, partial smoothing),
    which matters less than reliably arriving.

    #fig("wildfire_trophy.svg",
      [The firetruck wins the fancy trophy.],
      alt: "A gold star trophy")

    = References

    - Kavraki, L. E., Švestka, P., Latombe, J.-C., & Overmars, M. H.
      #link("https://doi.org/10.1109/70.508439")[Probabilistic roadmaps
      for path planning in high-dimensional configuration spaces], IEEE
      T-RA, 1996.
    - Reeds, J. A. & Shepp, L. A.
      #link("https://msp.org/pjm/1990/145-2/pjm-v145-n2-p06-s.pdf")[Optimal
      paths for a car that goes both forwards and backwards], Pacific
      Journal of Mathematics, 1990.
    - LaValle, S. M. #link("http://lavalle.pl/planning/")[Planning
      Algorithms], Cambridge University Press, 2006.
    - Geraerts, R. & Overmars, M. H.
      #link("https://doi.org/10.1177/0278364907079280")[Creating
      High-quality Paths for Motion Planning], IJRR, 2007.

    #post-nav("wildfire")
  ]
] <wildfire>

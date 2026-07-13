#import "../../lib/skeleton.typ": webpage
#import "../../lib/post.typ": post, fig, fig-grid, btn, post-nav

// Adapted from the full technical report (assets/docs/valet.pdf), which
// goes further: profiling methodology, the car-goal offset tuning, and a
// full derivation of the arc trajectory formula.
#let meta = (
  category: "motion planning",
  date: datetime(year: 2026, month: 4, day: 27),
  tags: ("python", "planning"),
  title: [Valet: Hybrid A\* Across Four Vehicle Types],
)

#webpage("posts/valet.html", title: meta.title)[
  #post(..meta)[
    A motion planning simulator that parks four vehicles of increasing
    difficulty — a holonomic point robot, a differential drive, an
    Ackermann car, and a truck towing a trailer — through randomly
    generated obstacle fields, using Hybrid A\* search. Built for RBE 550
    (Motion Planning) at WPI.

    #fig("valet_trailer_sim.png",
      [The trailer mid-playback. The traced path follows the rear axle;
        blue dots mark every state expanded during planning.],
      alt: "Simulator window showing a truck and trailer partway along a planned path through scattered obstacles")

    #btn(
      ([Full report (PDF) ↓], "../docs/valet.pdf"),
      ([Browse the source ↗], "https://github.com/ldjennings/valet"),
    )

    The project doubled as a testbed for two experiments: Python's
    structural typing (`typing.Protocol` and generics, inspired by Rust
    traits) to keep the four vehicle types interchangeable without an
    inheritance hierarchy, and Typst for the report — which came out
    deliberately excessive, because it was fun to make it so.

    = The Environment

    Each run scatters tetrominoes across a fixed grid until 10% of it is
    occupied, storing the result twice: a NumPy boolean grid for cheap
    lookups and a Shapely `STRtree` for exact intersection tests. The
    vehicle starts in the top-left corner and must reach a goal pose in
    the bottom-right — for the car, a parallel-parking spot against the
    bottom wall.

    #fig-grid((
      ("valet_goal_point.png", "Goal pose for the point robot"),
      ("valet_goal_diff.png", "Goal pose for the differential drive"),
      ("valet_goal_car.png", "Goal pose for the Ackermann car"),
      ("valet_goal_trailer.png", "Goal pose for the truck and trailer"),
    ), [Goal poses: point robot, differential drive, Ackermann car, and
      trailer. The car's spot is tuned so a genuine parallel-parking
      maneuver is both required and feasible.])

    = Hybrid A\*

    Hybrid A\* is A\* over a continuous state space: nodes carry exact
    $(x, y, theta)$ states (plus the trailer heading $phi$ when towing),
    and successors come from integrating sampled control inputs forward
    rather than stepping between grid cells. A discretized grid is used
    only for duplicate detection, so the search can't churn through
    near-identical states forever.

    #fig("valet_grid_spacing.svg",
      [The 1 m duplicate-detection grid against the car footprint:
        continuous states, discrete visited-set.],
      alt: "A car footprint overlaid on a coarse grid used for duplicate detection",
      width: 60%)

    == Motion Primitives

    Each expansion samples steering angles (or angular velocities, for
    the differential drive) crossed with forward/reverse. Holding the
    controls constant makes every primitive a circular arc, which has a
    closed-form solution — no numerical integration in the hot loop:

    $ x(i) &= x_0 + R dot (sin(theta(i)) - sin(theta_0)) \
      y(i) &= y_0 - R dot (cos(theta(i)) - cos(theta_0)) \
      theta(i) &= theta_0 + omega dot i dot d t $

    where $R = nu \/ omega$ is the signed turning radius. Ackermann and
    differential-drive kinematics both reduce to this same unicycle
    model; they differ only in which $R$ values they can produce. The
    differential drive can hit $R = 0$ (spin in place), so it gets extra
    rotate-in-place primitives whose cost is pure heading change —
    without them the planner can't exploit the drivetrain's signature
    move.

    #fig("valet_primitives.svg",
      [Primitives from one car state: five steering angles × forward
        (blue) and reverse (orange). Each arc extends just far enough to
        land in a new duplicate-detection cell.],
      alt: "Two plots of circular arc motion primitives fanning out from a car, forward arcs in blue and reverse arcs in orange")

    The heuristic is the obstacle-ignorant Reeds-Shepp path length to the
    goal — admissible, and much tighter than Euclidean distance for
    vehicles with a minimum turning radius. Landing *exactly* on the goal
    pose through discrete primitives is unlikely, so once the search gets
    within a terminal radius it starts attempting "last shot" closed-form
    connections (Reeds-Shepp for the car and trailer,
    rotate-drive-rotate for the differential drive), gated by a
    probability that scales up as the distance shrinks — each attempt
    costs a full collision check of the candidate path, so it's only
    worth trying where it's likely to be clear.

    = Making Collision Checking Fast

    Shapely was the correct-if-slow reference implementation: obstacles
    in an `STRtree`, vehicles as rotated polygons, exact intersection
    predicates. Profiling showed it dominating the runtime, so two
    optimizations were layered in front of it — chosen from `cProfile`
    data, not guesses.

    == Heading Cache

    Rotating a Shapely polygon walks every vertex through a matrix
    multiply, and the planner was doing it nearly a million times per
    run. Instead, each vehicle's footprint is pre-rotated to 72 headings
    (every 5°) at startup; a state query snaps to the nearest cached
    shape and defers the (cheap) translation until an exact check is
    actually needed.

    #fig("valet_heading_cache.svg",
      [Left: three of the 72 cached footprints. Right: the worst case —
        a true footprint at 22.5° against the cached 20° shape. An error
        requires an obstacle to intersect exclusively one of the thin
        discrepancy slivers (~3.5% of vehicle area).],
      alt: "Diagram of pre-rotated car footprints and the small angular discrepancy between a true footprint and its nearest cached shape")

    == AABB Rejection Filter

    Cached alongside each footprint is its axis-aligned bounding box, so
    translating it to a state is an offset addition. The box is tested
    against the field boundary, then against the obstacle grid cells it
    covers — and only if a cell is occupied does the exact Shapely check
    run. The filter eliminates the vast majority of exact tests at
    negligible cost, and since it can only produce false *positives*, it
    costs no accuracy.

    #fig("valet_aabb_check.svg",
      [A footprint at 35° with its AABB. The purple obstacle overlaps
        the box but not the car — a false positive the exact check
        resolves. Grey obstacles are skipped without any geometry work.],
      alt: "Diagram of a rotated car footprint inside its axis-aligned bounding box among grid obstacles")

    Together the two changes produced a 3.98× end-to-end speedup
    (81.5 s → 20.5 s on a profiled trailer run), with `rotate` calls
    dropping from 974,294 to 3,622. The control in the comparison is
    `propagate` (primitive generation), which is untouched by either
    change and shows identical cost in both profiles.

    #fig("valet_collision_opt.svg",
      [Call counts (top) and exclusive CPU time (bottom) before and
        after the collision optimizations.],
      alt: "Bar charts comparing call counts and CPU time of key functions in unoptimized and optimized profiles")

    One more trick: entire primitive trajectories are validated by
    checking only every 4th state. At the simulation timestep the car
    moves 0.167 m between states — far less than its 5.2 m body — so
    consecutive footprints overlap almost entirely, and a collision
    missed at a skipped state is nearly certain to appear at a checked
    one. The final accepted path gets an exact full-resolution pass.

    #fig("valet_path_overlap.svg",
      [Footprints along a 20-step arc. Orange outlines mark the checked
        states; the faint blue ones between are subsumed by them.],
      alt: "Overlapping car footprints along an arc with every fourth footprint outlined in orange")

    = The Trailer

    The truck follows the same closed-form arcs as any Ackermann
    vehicle, but the trailer heading is coupled through a nonlinear ODE,

    $ dot(phi) = frac(nu, M) sin(theta - phi) $

    where $M$ is the hitch-to-axle distance — no closed form alongside
    the arc, so $phi$ is stepped through the precomputed truck states
    with Euler's method. Any primitive that folds the rig past
    $|theta - phi| >= 90 degree$ is discarded as a jackknife, and
    last-shot connections are additionally rejected if the trailer
    arrives outside a heading tolerance.

    = Post-Processing

    The raw search output is valid but ugly — the search optimizes for
    reaching the goal, not for looking like driving. Two passes fix it:
    probabilistic shortcutting (pick two random path indices, try a
    direct Reeds-Shepp connection, keep it if collision-free, repeat 100
    times), then arc-length resampling so playback runs at constant
    velocity, with pure rotations resampled at their own angular rate.

    #fig-grid((
      ("valet_smooth_before.png", "Planned car path before smoothing, with a wide detour"),
      ("valet_smooth_after.png", "The same path after shortcutting, taking a direct route"),
    ), [The same car path before and after shortcutting: the detour
      imposed by search order gets replaced by direct connections.])

    = Results

    #fig-grid((
      ("valet_nav_point.png", "Completed point robot navigation"),
      ("valet_nav_diff.png", "Completed differential drive navigation"),
      ("valet_nav_car.png", "Completed car navigation ending in parallel parking"),
      ("valet_nav_trailer.png", "Completed trailer navigation"),
    ), [Completed runs for all four vehicles.])

    Over 10 runs per vehicle at 10% obstacle density:

    #table(
      columns: 5,
      stroke: none,
      table.header(
        [Vehicle], [State dims], [Success], [Avg time], [Avg expansions],
      ),
      [Differential drive], [$x, y, theta$], [10/10], [1.3 s], [1930],
      [Ackermann car], [$x, y, theta$], [8/10], [1.3 s], [1905],
      [Trailer], [$x, y, theta, phi$], [7/10], [9.5 s], [8548],
    )

    The car's misses trace to an unhandled edge case — its footprint
    occasionally spawns boxed in by obstacles. The trailer pays for its
    fourth state dimension and per-step ODE work, and some of its
    failures are genuine: layouts with no reachable path under the
    jackknife constraint. Failed runs exhaust the search space and
    terminate cleanly rather than hanging.

    The typing experiment held up too: the `Protocol`-based vehicle
    interface kept all four vehicles swappable through one planner, and
    parameter tuning rarely broke anything unexpected. Whether the
    up-front type-system work paid for itself is debatable — but it
    survived contact with the trailer.

    = References

    - Reeds, J. A. & Shepp, L. A.
      #link("https://msp.org/pjm/1990/145-2/pjm-v145-n2-p06-s.pdf")[Optimal
      paths for a car that goes both forwards and backwards], Pacific
      Journal of Mathematics, 1990.
    - Dolgov, D., Thrun, S., Montemerlo, M., & Diebel, J.
      #link("https://ai.stanford.edu/~ddolgov/papers/dolgov_gpp_stair08.pdf")[Practical
      Search Techniques in Path Planning for Autonomous Driving], 2008.
    - Kurzer, K.
      #link("https://urn.kb.se/resolve?urn=urn:nbn:se:kth:diva-198534")[Path
      Planning in Unstructured Environments: A Real-time Hybrid A\*
      Implementation], KTH, 2016.
    - LaValle, S. M. #link("http://lavalle.pl/planning/")[Planning
      Algorithms], Cambridge University Press, 2006.
    - Geraerts, R. & Overmars, M. H.
      #link("https://doi.org/10.1177/0278364907079280")[Creating
      High-quality Paths for Motion Planning], IJRR, 2007.
    - Amanatides, J. & Woo, A.
      #link("https://doi.org/10.2312/egtp.19871000")[A Fast Voxel
      Traversal Algorithm for Ray Tracing], Eurographics, 1987.

    #post-nav("valet")
  ]
] <valet>

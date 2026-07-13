// Staging: collects every page document and shared asset into one bundle.
// Compile with `just watch` / `just build` (typst -f bundle), or `nix build`.
// Webfont files are copied in next to these by the flake (fonts/).

#include "pages/index.typ"
#include "pages/about.typ"
#include "pages/posts/maze-robot.typ"
#include "pages/posts/reinforcement-learning.typ"
#include "pages/posts/deraining.typ"
#include "pages/posts/robot-arm.typ"
#include "pages/posts/quadrotor.typ"
#include "pages/posts/formula-electric.typ"
#include "pages/posts/symbotic.typ"
#include "pages/posts/valet.typ"
#include "pages/posts/transmission.typ"
#include "pages/posts/wildfire.typ"
#include "pages/resume.typ"
#include "pages/notfound.typ"

#asset("layout.css", read("assets/layout.css"))
#asset("theme.css", read("assets/theme.css"))

// The typeset resume sheet, committed here by the Resume repo's CI
// whenever a new one is published (see README, Deployment).
#asset("resume.pdf", read("assets/resume.pdf", encoding: none))
#asset("resume.svg", read("assets/resume.svg", encoding: none))

#for f in (
  "logo.jpg",
  "real-motion.png",
  "real-sym.svg",
  "real-formula.jpg",
  "real-quad.png",
  "real-arm.jpg",
  "real-derain.png",
  "derain_pair.jpg",
  "derain_pair2.jpg",
  "derain_tuning.jpg",
  "derain_training.jpg",
  "derain_testing.jpg",
  "formula_inverter_pcb.png",
  "formula_radio_3d_poster.png",
  "formula_pedalbox.png",
  "quadrotor_result.png",
  "arm_home_pose.png",
  "arm_dims.png",
  "arm_dynamics.png",
  "romi.jpg",
  "valet_trailer_sim.png",
  "valet_goal_point.png",
  "valet_goal_diff.png",
  "valet_goal_car.png",
  "valet_goal_trailer.png",
  "valet_primitives.svg",
  "valet_grid_spacing.svg",
  "valet_heading_cache.svg",
  "valet_aabb_check.svg",
  "valet_path_overlap.svg",
  "valet_collision_opt.svg",
  "valet_smooth_before.png",
  "valet_smooth_after.png",
  "valet_nav_point.png",
  "valet_nav_diff.png",
  "valet_nav_car.png",
  "valet_nav_trailer.png",
  "wildfire_sim.png",
  "wildfire_states.svg",
  "wildfire_stuck_start.png",
  "wildfire_truck_stuck.png",
  "wildfire_cpu_times.png",
  "wildfire_trophy.svg",
  "trans_overview.png",
  "trans_shaft_full.png",
  "trans_shaft_simp.png",
  "trans_spherical.svg",
  "trans_path.png",
  "trans_trees.png",
  "trans_frames.png",
) {
  asset("img/" + f, read("assets/img/" + f, encoding: none))
}

// Interactive 3D models (post.typ's fig3d): meshopt-compressed glTF,
// produced by the pipeline in README (KiCad → Blender → gltfpack -cc).
// The viewer scripts themselves are pinned through the flake, not here.
#for f in ("radio.glb",) {
  asset("models/" + f, read("assets/models/" + f, encoding: none))
}

// Report PDFs and code archives referenced by the write-ups.
#for f in (
  "valet.pdf",
  "wildfire.pdf",
  "transmission.pdf",
  "valet-code.zip",
  "wildfire-code.zip",
  "transmission-code.zip",
  "robot-arm-report.pdf",
  "rl-report.pdf",
  "romi-code.zip",
  "rl-code.zip",
) {
  asset("docs/" + f, read("assets/docs/" + f, encoding: none))
}

// Staging: collects every page document and shared asset into one bundle.
// Compile with `just watch` / `just build` (typst -f bundle), or `nix build`.
// Webfont files are copied in next to these by the flake (fonts/).

#include "pages/index.typ"
#include "pages/about.typ"
#include "pages/maze-robot.typ"
#include "pages/reinforcement-learning.typ"
#include "pages/deraining.typ"
#include "pages/robot-arm.typ"
#include "pages/quadrotor.typ"
#include "pages/formula-electric.typ"
#include "pages/symbotic.typ"
#include "pages/motion-planning.typ"
#include "pages/resume.typ"
#include "pages/notfound.typ"

#asset("layout.css", read("assets/layout.css"))
#asset("theme.css", read("assets/theme.css"))

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
  "formula_radio_pcb.png",
  "formula_pedalbox.png",
  "quadrotor_result.png",
  "arm_home_pose.png",
  "arm_dims.png",
  "arm_dynamics.png",
  "romi.jpg",
) {
  asset("img/" + f, read("assets/img/" + f, encoding: none))
}

// Report PDFs and code archives referenced by the write-ups.
#for f in (
  "valet.pdf",
  "wildfire.pdf",
  "transmission.pdf",
  "robot-arm-report.pdf",
  "rl-report.pdf",
  "romi-code.zip",
  "rl-code.zip",
) {
  asset("docs/" + f, read("assets/docs/" + f, encoding: none))
}

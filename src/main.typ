// Staging: collects every page document and shared asset into one bundle.
// Compile with `just watch` / `just build` (typst -f bundle), or `nix build`.
// Webfont files are copied in next to these by the flake (fonts/).

#include "pages/index.typ"
#include "pages/formula-electric.typ"

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
  "formula_inverter_pcb.png",
  "formula_radio_pcb.png",
  "formula_pedalbox.png",
) {
  asset("img/" + f, read("assets/img/" + f, encoding: none))
}

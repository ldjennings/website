// Staging: collects every page document and shared asset into one bundle.
// Compile with `just watch` / `just build` (typst -f bundle), or `nix build`.

#include "pages/index.typ"
#include "pages/blog.typ"

#asset(
  "favicon.ico",
  read("assets/favicon.ico", encoding: none),
)

#asset("main.css", read("assets/main.css"))

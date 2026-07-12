#!/usr/bin/env python3
"""Hoist head content typst leaves at the top of <body> into <head>.

Typst's bundle export only writes into <body>, so the page chrome's <meta>,
<link>, and <base> tags (skeleton.typ's head-stuff) land there. Browsers
apply them anyway, but Firefox paints the page before in-body stylesheets
finish loading — a flash of unstyled content on every navigation. Once the
stylesheets sit in <head>, they block the first paint like normal.

Exits nonzero when no page needed rewriting: that means typst has learned
to emit <head> content itself and this step should be retired.

Usage: hoist-head.py <site-dir>    (rewrites the .html files in place)
"""

import re
import sys
from pathlib import Path

# The uninterrupted run of head-eligible tags at the very start of <body>.
LEADING = re.compile(r"(<body[^>]*>)((?:\s*<(?:meta|link|base)\b[^>]*>)+)")


def hoist(page: Path) -> bool:
    html = page.read_text()
    m = LEADING.search(html)
    if m is None or "</head>" not in html[: m.start()]:
        return False
    stripped = html[: m.start()] + m.group(1) + html[m.end() :]
    head, _, rest = stripped.partition("</head>")
    page.write_text(head + m.group(2) + "</head>" + rest)
    return True


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <site-dir>")
    pages = sorted(Path(sys.argv[1]).rglob("*.html"))
    done = sum(hoist(p) for p in pages)
    print(f"head hoist: {done}/{len(pages)} pages rewritten")
    if done == 0:
        sys.exit(
            "head hoist: nothing to move — typst may now emit <head> content"
            " itself; check a built page and retire this step (see README)"
        )


if __name__ == "__main__":
    main()

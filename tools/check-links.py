#!/usr/bin/env python3
"""Dead-link audit for the built site bundle.

Usage: check-links.py <bundle-dir>

Walks every .html file and verifies that each local href/src points at a
file that exists, and that each fragment points at an id that exists in
its target page. Exits nonzero listing every dead link found.
"""

import os
import re
import sys
import urllib.parse

root = sys.argv[1]

pages = {}
for dirpath, _, files in os.walk(root):
    for f in files:
        if f.endswith(".html"):
            p = os.path.join(dirpath, f)
            pages[p] = open(p, encoding="utf-8").read()

ids = {p: set(re.findall(r'id="([^"]+)"', html)) for p, html in pages.items()}

bad = []
for page, html in pages.items():
    # 404.html is served at arbitrary URLs and carries <base href="/">:
    # its relative links resolve from the bundle root, not its own dir.
    base = root if os.path.basename(page) == "404.html" else os.path.dirname(page)
    # poster covers <model-viewer>'s placeholder image attribute.
    for url in re.findall(r'(?:href|src|poster)="([^"]+)"', html):
        if url.startswith(("http://", "https://", "mailto:", "data:")):
            continue
        parts = urllib.parse.urlsplit(url)
        path = urllib.parse.unquote(parts.path)
        if path.startswith("/"):  # site-absolute -> bundle root
            target = os.path.normpath(os.path.join(root, path.lstrip("/")))
        elif path:
            target = os.path.normpath(os.path.join(base, path))
        else:  # fragment-only link into the same page
            target = page
        if path and not os.path.exists(target):
            bad.append((page, url, "missing file"))
        elif parts.fragment and target in pages and parts.fragment not in ids[target]:
            bad.append((page, url, f"missing #{parts.fragment}"))

for page, url, why in bad:
    print(f"{os.path.relpath(page, root)}: {url} ({why})")
if bad:
    sys.exit(1)
print(f"link audit: {len(pages)} pages, all local links resolve")

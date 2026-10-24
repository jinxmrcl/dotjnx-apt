#!/bin/sh
# GitHub Pages needs a few minutes after a push: wait until it serves the InRelease of this commit.
for i in $(seq 90); do
  if curl -fsSL "https://jinxmrcl.github.io/dotjnx-apt/dists/stable/InRelease?v=$i$(date +%s)" 2> /dev/null | cmp -s - dists/stable/InRelease; then
    echo "GitHub Pages liefert diesen Stand aus"
    exit 0
  fi
  sleep 10
done
echo "GitHub Pages liefert nach 15 Minuten noch einen anderen Stand" >&2
exit 1

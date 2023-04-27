#! /usr/bin/env bash
set -euo pipefail
F=$HOME/Screenshots/$(date +"%Y-%m-%d_%H%m%S").png
grim -g "$(slurp)" $F
echo $F
echo $F | wl-copy
notify-desktop "Screenshot saved to $F"

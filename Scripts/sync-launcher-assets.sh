#!/bin/zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
SITE_ROOT=${SCRIPT_DIR:h}
SOURCE_DIR=${GAMEPAC_PREVIEW_DIR:-${SITE_ROOT:h}/GamePac/Previews}

# Only read these approved ARCADE renders; never regenerate the source previews.
sources=(clubhouse-arcade clubhouse-states-arcade clubhouse-detail-arcade)
outputs=(launcher-arcade launcher-states-arcade launcher-detail-arcade)
widths=(1440 1100 1100)

for source in "${sources[@]}"; do
    [[ -f "$SOURCE_DIR/$source.png" ]] || { print -u2 "Missing $SOURCE_DIR/$source.png"; exit 1; }
done

STAGE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/gamepac-launcher-assets.XXXXXX")
trap 'rm -rf "$STAGE_DIR"' EXIT

for i in {1..3}; do
    /usr/bin/sips -Z "${widths[$i]}" -s format jpeg -s formatOptions 82 \
        "$SOURCE_DIR/${sources[$i]}.png" --out "$STAGE_DIR/${outputs[$i]}.jpg" >/dev/null
    bytes=$(stat -f %z "$STAGE_DIR/${outputs[$i]}.jpg")
    (( bytes <= 307200 )) || { print -u2 "Asset exceeds 300 KiB: ${outputs[$i]} ($bytes bytes)"; exit 1; }
    printf '%-32s %8d bytes\n' "${outputs[$i]}.jpg" "$bytes"
done

for output in "${outputs[@]}"; do
    install -m 0644 "$STAGE_DIR/$output.jpg" "$SITE_ROOT/assets/$output.jpg"
done

#!/bin/zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
SITE_ROOT=${SCRIPT_DIR:h}
DEVELOPER_ROOT=${GAMEPAC_DEVELOPER_ROOT:-${SITE_ROOT:h}}
ASSET_DIR="$SITE_ROOT/assets"
STAGE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/gamepac-assets.XXXXXX")

cleanup() {
    rm -rf "$STAGE_DIR"
}
trap cleanup EXIT

typeset -A SOURCES
SOURCES[minesweeper_icon]="$DEVELOPER_ROOT/MineSweeper/MineSweeper/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png"
SOURCES[dottie_icon]="$DEVELOPER_ROOT/Dottie/Dottie/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png"
SOURCES[tilly_icon]="$DEVELOPER_ROOT/Tilly/Tilly/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png"
SOURCES[minesweeper_shot]="$DEVELOPER_ROOT/MineSweeper/VisualEvidence/proposal3/modern-cascade-resting.png"
SOURCES[dottie_shot]="$DEVELOPER_ROOT/Dottie/Previews/ready-modern.png"
SOURCES[tilly_shot]="$DEVELOPER_ROOT/Tilly/Previews/midgame-modern.png"

for source_file in "${SOURCES[@]}"; do
    if [[ ! -f "$source_file" ]]; then
        print -u2 "Missing required source asset: $source_file"
        exit 1
    fi
done

if ! command -v sips >/dev/null 2>&1; then
    print -u2 "sync-assets.sh requires the macOS sips tool."
    exit 1
fi

if ! command -v xcrun >/dev/null 2>&1; then
    print -u2 "sync-assets.sh requires Xcode command-line tools."
    exit 1
fi

downsample_png() {
    local source_file=$1
    local output_file=$2
    /usr/bin/sips -Z 256 "$source_file" --out "$output_file" >/dev/null
}

downsample_jpeg() {
    local source_file=$1
    local output_file=$2
    /usr/bin/sips -Z 1100 -s format jpeg -s formatOptions 82 "$source_file" --out "$output_file" >/dev/null
}

downsample_png "${SOURCES[minesweeper_icon]}" "$STAGE_DIR/minesweeper-icon.png"
downsample_png "${SOURCES[dottie_icon]}" "$STAGE_DIR/dottie-icon.png"
downsample_png "${SOURCES[tilly_icon]}" "$STAGE_DIR/tilly-icon.png"

downsample_jpeg "${SOURCES[minesweeper_shot]}" "$STAGE_DIR/minesweeper-modern.jpg"
downsample_jpeg "${SOURCES[dottie_shot]}" "$STAGE_DIR/dottie-modern.jpg"
downsample_jpeg "${SOURCES[tilly_shot]}" "$STAGE_DIR/tilly-modern.jpg"

CLANG_MODULE_CACHE_PATH="$STAGE_DIR/module-cache" \
    xcrun swift "$SCRIPT_DIR/render-brand.swift" "$STAGE_DIR"

generated_files=(
    minesweeper-icon.png dottie-icon.png tilly-icon.png \
    minesweeper-modern.jpg dottie-modern.jpg tilly-modern.jpg \
    game-pac-mark-light.png game-pac-mark-dark.png favicon.png og-game-pac.png
)

typeset -i total_bytes=0
for generated_file in "${generated_files[@]}"; do
    file_bytes=$(stat -f %z "$STAGE_DIR/$generated_file")
    total_bytes+=file_bytes
    if (( file_bytes > 307200 )); then
        print -u2 "Generated asset exceeds 300 KB: $generated_file ($file_bytes bytes)"
        exit 1
    fi
    printf '%-30s %8d bytes\n' "$generated_file" "$file_bytes"
done

if (( total_bytes > 2621440 )); then
    print -u2 "Generated assets exceed the 2.5 MB page budget: $total_bytes bytes"
    exit 1
fi

mkdir -p "$ASSET_DIR"
for generated_file in "${generated_files[@]}"; do
    install -m 0644 "$STAGE_DIR/$generated_file" "$ASSET_DIR/$generated_file"
done

printf 'Total asset weight: %d bytes\n' "$total_bytes"

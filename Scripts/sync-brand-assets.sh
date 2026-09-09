#!/bin/zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
SITE_ROOT=${SCRIPT_DIR:h}
DEVELOPER_ROOT=${GAMEPAC_DEVELOPER_ROOT:-${SITE_ROOT:h}}
ASSET_DIR="$SITE_ROOT/assets"
ICON_SOURCE=${GAMEPAC_ICON_SOURCE:-"$DEVELOPER_ROOT/GamePacBriefs/icon-2026-09-08/MASTER.png"}
STAGE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/gamepac-brand.XXXXXX")

cleanup() {
    rm -rf "$STAGE_DIR"
}
trap cleanup EXIT

if [[ ! -f "$ICON_SOURCE" ]]; then
    print -u2 "Missing approved arcade icon source: $ICON_SOURCE"
    print -u2 "Set GAMEPAC_ICON_SOURCE to the approved MASTER.png artwork."
    exit 1
fi

game_icons=(
    minesweeper-icon.png dottie-icon.png tilly-icon.png suki-icon.png
)

for game_icon in "${game_icons[@]}"; do
    if [[ ! -f "$ASSET_DIR/$game_icon" ]]; then
        print -u2 "Missing existing game icon: $ASSET_DIR/$game_icon"
        exit 1
    fi
    install -m 0644 "$ASSET_DIR/$game_icon" "$STAGE_DIR/$game_icon"
done

if ! command -v sips >/dev/null 2>&1; then
    print -u2 "sync-brand-assets.sh requires the macOS sips tool."
    exit 1
fi

if ! command -v xcrun >/dev/null 2>&1; then
    print -u2 "sync-brand-assets.sh requires Xcode command-line tools."
    exit 1
fi

CLANG_MODULE_CACHE_PATH="$STAGE_DIR/module-cache" \
    xcrun swift "$SCRIPT_DIR/render-brand.swift" "$STAGE_DIR" "$ICON_SOURCE"

brand_files=(
    game-pac-mark-light.png game-pac-mark-dark.png favicon.png apple-touch-icon.png og-game-pac.png
)

typeset -A EXPECTED_DIMS
EXPECTED_DIMS[game-pac-mark-light.png]="84 84"
EXPECTED_DIMS[game-pac-mark-dark.png]="84 84"
EXPECTED_DIMS[favicon.png]="64 64"
EXPECTED_DIMS[apple-touch-icon.png]="180 180"
EXPECTED_DIMS[og-game-pac.png]="1200 630"

typeset -A BUDGETS
BUDGETS[game-pac-mark-light.png]=30720
BUDGETS[game-pac-mark-dark.png]=30720
BUDGETS[favicon.png]=20480
BUDGETS[apple-touch-icon.png]=102400
BUDGETS[og-game-pac.png]=307200

for brand_file in "${brand_files[@]}"; do
    staged_file="$STAGE_DIR/$brand_file"
    if [[ ! -f "$staged_file" ]]; then
        print -u2 "Renderer did not produce: $brand_file"
        exit 1
    fi

    pixel_width=$(/usr/bin/sips -g pixelWidth "$staged_file" | awk '/pixelWidth/ {print $2}')
    pixel_height=$(/usr/bin/sips -g pixelHeight "$staged_file" | awk '/pixelHeight/ {print $2}')
    expected=(${=EXPECTED_DIMS[$brand_file]})
    if [[ "$pixel_width" != "${expected[1]}" || "$pixel_height" != "${expected[2]}" ]]; then
        print -u2 "Unexpected dimensions for $brand_file: ${pixel_width}x${pixel_height}, expected ${expected[1]}x${expected[2]}"
        exit 1
    fi

    file_bytes=$(stat -f %z "$staged_file")
    if (( file_bytes > BUDGETS[$brand_file] )); then
        print -u2 "Generated asset exceeds its budget: $brand_file ($file_bytes > ${BUDGETS[$brand_file]} bytes)"
        exit 1
    fi
    printf '%-30s %4sx%-4s %8d bytes\n' "$brand_file" "$pixel_width" "$pixel_height" "$file_bytes"
done

for brand_file in "${brand_files[@]}"; do
    install -m 0644 "$STAGE_DIR/$brand_file" "$ASSET_DIR/$brand_file"
done

print "Installed ${#brand_files[@]} brand assets from $ICON_SOURCE"

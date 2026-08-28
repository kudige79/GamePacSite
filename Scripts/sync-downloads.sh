#!/bin/zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
SITE_ROOT=${SCRIPT_DIR:h}
DEVELOPER_ROOT=${GAMEPAC_DEVELOPER_ROOT:-${SITE_ROOT:h}}
STAGE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/gamepac-downloads.XXXXXX")

cleanup() {
    rm -rf -- "$STAGE_DIR"
}
trap cleanup EXIT

slugs=(minesweeper dottie tilly suki)
repo_directories=(MineSweeper Dottie Tilly Suki)
file_prefixes=(MineSweeper Dottie Tilly Suki)

mkdir -p "$STAGE_DIR/downloads" "$STAGE_DIR/updates"

for (( index = 1; index <= ${#slugs[@]}; index++ )); do
    slug=${slugs[$index]}
    repo_directory=${repo_directories[$index]}
    file_prefix=${file_prefixes[$index]}
    dist_directory="$DEVELOPER_ROOT/$repo_directory/dist"
    source_appcast="$dist_directory/appcast.xml"
    versioned_dmgs=("$dist_directory/$file_prefix"-*.dmg(N))

    if (( ${#versioned_dmgs[@]} == 0 )); then
        print -u2 "No versioned $file_prefix DMG found in $dist_directory"
        exit 1
    fi

    if [[ ! -f "$source_appcast" ]]; then
        print -u2 "Missing appcast: $source_appcast"
        exit 1
    fi

    mkdir -p "$STAGE_DIR/updates/$slug"
    for source_dmg in "${versioned_dmgs[@]}"; do
        install -m 0644 "$source_dmg" "$STAGE_DIR/downloads/${source_dmg:t}"
    done

    /usr/bin/sed -E \
        's#https://github\.com/kudige79/[^/]+/releases/download/v[^/]+/([^" ]+\.dmg)#https://game-pac.com/downloads/\1#g' \
        "$source_appcast" > "$STAGE_DIR/updates/$slug/appcast.xml"

    if /usr/bin/grep -q 'github\.com/kudige79' "$STAGE_DIR/updates/$slug/appcast.xml"; then
        print -u2 "Private-repository URL remains in $slug appcast"
        exit 1
    fi

    update_urls=("${(@f)$(/usr/bin/grep -oE 'https://game-pac\.com/downloads/[^" ]+\.dmg' "$STAGE_DIR/updates/$slug/appcast.xml")}")
    if (( ${#update_urls[@]} == 0 )); then
        print -u2 "No game-pac.com enclosure found in $slug appcast"
        exit 1
    fi

    for update_url in "${update_urls[@]}"; do
        update_file=${update_url:t}
        if [[ ! -f "$STAGE_DIR/downloads/$update_file" && ! -f "$SITE_ROOT/downloads/$update_file" ]]; then
            print -u2 "Appcast references a DMG that is not hosted by the site: $update_file"
            exit 1
        fi
    done
done

mkdir -p "$SITE_ROOT/downloads"
for staged_dmg in "$STAGE_DIR"/downloads/*.dmg(N); do
    install -m 0644 "$staged_dmg" "$SITE_ROOT/downloads/${staged_dmg:t}"
done

for slug in "${slugs[@]}"; do
    mkdir -p "$SITE_ROOT/updates/$slug"
    install -m 0644 "$STAGE_DIR/updates/$slug/appcast.xml" "$SITE_ROOT/updates/$slug/appcast.xml"
done

print "Staged Game Pac downloads:"
/usr/bin/shasum -a 256 "$SITE_ROOT"/downloads/*.dmg
print "Staged update feeds:"
/usr/bin/shasum -a 256 "$SITE_ROOT"/updates/*/appcast.xml

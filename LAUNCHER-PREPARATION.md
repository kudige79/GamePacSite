# Launcher preparation — 2026-09-05

Prepared locally on `site/launcher`, based on
`ecc1f3dbdcc0ceb36a63472fc58d936d40128fd5`. This is not a release or deployment.

## Changes

- Replaced the teaser with the real ARCADE collection overview, status preview,
  and detail preview. Preserved the source images without repainting or cropping.
- Added install/verify/update/launch copy and macOS 14.0 requirements, with
  Mine Sweeper, Dottie, Tilly and Suki linked as individually available and
  Shatranj explicitly coming soon. No unreleased sixth title appears.
- Added a native disabled download button, consistent app links in the primary
  and footer navigation, and a count-independent heading.
- Used the existing HTML/CSS structure, custom properties, dark-mode tokens,
  responsive breakpoints, focus styles and reduced-motion handling. No JS,
  framework or external dependency was added.

## Release edit point

The single `LAUNCHER RELEASE` block in `index.html` contains the disabled button,
coming-soon status, requirements and availability sentence. Replace the button
with an anchor to the verified DMG, change the status to the actual version,
and remove the unavailability sentence. Detailed steps are in `README.md`.
There is currently no launcher download URL, placeholder href or fabricated
version in this block.

## Assets

Source directory: `~/Developer/GamePac/Previews/` (read-only).
All sources are 2160 × 1320 PNGs. Outputs are JPEG quality 82, matching the
site's existing screenshot format and flat `assets/` naming convention.

| Source → asset | Source bytes | Web bytes | Web dimensions |
| --- | ---: | ---: | --- |
| `clubhouse-arcade.png` → `launcher-arcade.jpg` | 2,354,329 | 163,845 | 1440 × 880 |
| `clubhouse-states-arcade.png` → `launcher-states-arcade.jpg` | 2,332,986 | 108,540 | 1100 × 672 |
| `clubhouse-detail-arcade.png` → `launcher-detail-arcade.jpg` | 1,812,292 | 110,964 | 1100 × 672 |
| Total | 6,499,607 | 383,349 | |

Reduction: 94.1%. Each image has descriptive alt text, explicit dimensions,
lazy loading and async decoding. `Scripts/sync-launcher-assets.sh` regenerates
only these assets, checks the 300 KiB per-image budget and never writes to the
source repository. Source and optimized images were visually inspected.

## Verification

Passed:

- `git diff --check` and `zsh -n Scripts/sync-launcher-assets.sh`.
- Structural HTML parsing: balanced explicit tags, unique IDs and attributes,
  all ARIA references resolve, one H1 and no skipped heading levels.
- All 19 internal anchors and 23 local file references resolve on disk,
  including the four existing game downloads. No launcher href is present.
- All three new image dimensions match the markup and fit the size budget.
- Native disabled button and correct roster/status/requirements in the HTML.
- A second asset generation produced byte-identical JPEGs.
- SHA-256 checks confirm all three source PNGs remained unchanged.

Not verified:

- Desktop/tablet/mobile rendering in light and dark, horizontal overflow,
  in-browser image loading, keyboard interaction and rendered contrast.
  Chrome could not start in the sandbox; a local HTTP server was denied;
  Computer Use reported “Computer Use was not approved to use Safari”.
  No reason for the Safari rejection was supplied.
- Full HTML5 conformance validation. No modern validator was installed; fetching
  one failed under the network restriction. The available 2006 HTML Tidy is
  not an HTML5 validator. Structural parsing above is not a substitute.

These are pending checks before publication; responsive CSS inspection alone
is not browser evidence. The site has no build or test system to compile/run.
The temporary check script, result JSON, source hashes and Kimi failure log
are in `/private/tmp/gamepac-site-launcher-20260905/`.

## Existing content and isolation

No broken local links or heading-order defects were found in the existing page.
The approved launcher renders contain example game versions/statuses, including
an illustrative macOS 15 requirement in the status view. The new caption labels
these as examples; the launcher's actual requirement remains macOS 14.0.

The user's correction supersedes the original brief's worktree setup and
sibling-status instructions. No fetch, new worktree, push, deploy, remote
configuration change, or git command targeting `GamePacSite-suki` was run.
Consequently no sibling status output is claimed. No source file in `GamePac`
was modified. Existing downloads, update feeds, icons and social metadata
were left untouched.

Kimi was attempted first as instructed but failed before implementation with
“storage write failed: permission denied” and file-watcher errors. Codex
implemented the brief directly as the authorized fallback.

---

## Runtime infrastructure preparation — 2026-09-08

This section supplements the historical marketing report above. Work is local
on `site/launcher`, starting at `5e3fa90`. No publication is performed here.

### Exact runtime paths

| Repository path | Canonical runtime URL | Prepared state |
| --- | --- | --- |
| `icons/<id>.png` | `https://game-pac.com/icons/<id>.png` | Five original PNGs copied; includes hidden/unreleased Woozy |
| `catalog.json` | `https://game-pac.com/catalog.json` | Reserved root file path; awaiting owner-approved signed bytes |
| `catalog.json.sig` | `https://game-pac.com/catalog.json.sig` | Reserved root file path; awaiting matching detached signature |
| `updates/gamepac/appcast.xml` | `https://game-pac.com/updates/gamepac/appcast.xml` | Directory documented; awaiting actual release feed |
| `downloads/` | Versioned enclosure URLs from the actual release feed | Existing directory; no launcher DMG added |

Do not place the signed pair in `assets/`, `updates/`, or directories named
`catalog.json`/`catalog.json.sig`. Publish both root files in the same commit,
without parsing/reserializing JSON, newline conversion, metadata stripping or
other byte changes. No copy of the current GamePac root pair was made. No
signature, appcast, launcher version, enclosure URL or DMG was fabricated.

### Icon integrity

Read-only source: `/Users/kudige/Developer/GamePac/icons/`. Pins come from
`/Users/kudige/Developer/GamePac/catalog.json`. All five copies were compared
both byte-for-byte with the source and by SHA-256 with the catalog pin.

| Icon | Catalog `iconSHA256` | Site PNG SHA-256 | Result |
| --- | --- | --- | --- |
| minesweeper | `714ffb68094ab855d037c558b006c306dae2235525463dc2bb79f3b7cd7f0b58` | `714ffb68094ab855d037c558b006c306dae2235525463dc2bb79f3b7cd7f0b58` | MATCH |
| dottie | `1635d294f402234e5948e9fc7ad8dafd60c40a306dc502b5148a7e9deab9ab88` | `1635d294f402234e5948e9fc7ad8dafd60c40a306dc502b5148a7e9deab9ab88` | MATCH |
| tilly | `4798d48fd68c32efa5ad8915b40f856e56e736a2774cd216b7e4af28da36a705` | `4798d48fd68c32efa5ad8915b40f856e56e736a2774cd216b7e4af28da36a705` | MATCH |
| suki | `e8a2966c534ab4775440dfae8e01c9b704fd11d839e830fe81fadf2a31300050` | `e8a2966c534ab4775440dfae8e01c9b704fd11d839e830fe81fadf2a31300050` | MATCH |
| woozy | `214a8ba184eb2082667bcdb9ab4eda2eab06ed1646a7e0638eeb2c407506dfd0` | `214a8ba184eb2082667bcdb9ab4eda2eab06ed1646a7e0638eeb2c407506dfd0` | MATCH |

Sizes respectively: 761,295; 638,181; 124,852; 1,430,389; 1,575,695 bytes.
These are deliberate runtime originals, not the optimized marketing icons in
`assets/`. Any hash mismatch is a hard stop.

### Byte preservation and GitHub Pages limits

The site has no build step. `sync-assets.sh` and `sync-launcher-assets.sh`
write named files only under `assets/`; `sync-downloads.sh` handles the four
existing titles' downloads and feeds. None rewrites root `icons/` or the
catalog pair. No asset-script exclusion change is necessary.

The empty root `.nojekyll` disables Pages' default Jekyll processing for a
branch-based site. `.gitattributes` disables text conversion, filters and
ident expansion on the two exact catalog paths and root icon PNGs. There are
no new rewrite or redirect rules. Keep these protections when publishing.
[GitHub Pages static-site documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site#static-site-generators)

Pages controls MIME types and does not allow per-file/repository overrides.
The current `mime-db` mappings are `image/png`, `application/json`,
`application/xml`, and **`application/pgp-signature` for `.sig`**. The last is
an extension-based label, not the actual Ed25519 signature format. A precise
Ed25519-specific or `application/octet-stream` header cannot be guaranteed
on the current Pages host. `_headers` and `.htaccess` would not fix that.
This is an unresolved limitation of the brief's strict content-type request;
it does not itself change response bytes. Verify actual headers after
publication. No host migration or launcher change is included here.
[Pages MIME policy](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site#mime-types-on-github-pages),
[mime-db](https://github.com/jshttp/mime-db/blob/master/db.json)

No configured build transformation remains that would alter these files.
Lossless HTTP compression changes transfer encoding, not the decoded body
that must match the signed file. Caches can serve older bytes (including
negative responses); separate catalog and signature requests can therefore
see different generations during rollout. That is a consistency risk, not
JSON reformatting. Publishing the pair together does not prove atomic updates
at every cache. Require live exact-body comparisons and signature verification;
never claim a fixed cache TTL or treat a cache-busting URL as proof that the
canonical URL works. GitHub's stated publication delay of up to ten minutes
is not a cache-expiration guarantee.
[HTTP content codings](https://www.rfc-editor.org/rfc/rfc9110.html#section-8.4.1),
[HTTP caching](https://www.rfc-editor.org/rfc/rfc9111.html#section-4.2),
[Pages publication timing](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site#viewing-your-published-site)

The canonical URLs already use HTTPS and the apex domain. Live status 200,
no redirect, MIME headers and decoded body bytes remain publication checks;
local files cannot establish those facts about a future deployment.

### One command to verify the published catalog signature

Run this whole subshell command on the owner's Mac after publishing. It
requires the existing read-only CryptoKit verifier and Xcode, uses no private
key, follows no redirect, and verifies the exact downloaded JSON bytes. It
also prints the response content types. A non-200 or signature mismatch fails.
This checks authenticity; use the owner sequence below to also compare with
the intended release files and prove freshness.

```bash
(
  set -euo pipefail
  CHECK_DIR="$(mktemp -d /private/tmp/gamepac-catalog-check.XXXXXX)"
  trap 'rm -rf "$CHECK_DIR"' EXIT
  for NAME in catalog.json catalog.json.sig; do
    HTTP_CODE="$(curl --disable --fail --silent --show-error --compressed \
      --proto '=https' --max-redirs 0 --connect-timeout 20 --max-time 120 \
      --dump-header "$CHECK_DIR/$NAME.headers" \
      --output "$CHECK_DIR/$NAME" --write-out '%{http_code}' \
      "https://game-pac.com/$NAME")"
    test "$HTTP_CODE" = 200
    rg -i '^content-type:' "$CHECK_DIR/$NAME.headers"
  done
  DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
    CLANG_MODULE_CACHE_PATH="$CHECK_DIR/module-cache" \
    swift /Users/kudige/Developer/GamePac/scripts/verify-signature.swift \
    "$CHECK_DIR/catalog.json" "$CHECK_DIR/catalog.json.sig"
)
```

### Owner-only future publication sequence

**These are future instructions, not actions performed during this task.**
First obtain the final signed pair and the signed/notarized versioned launcher
DMG(s), plus the owner-generated `GamePac/dist/appcast.xml`. Complete the
outstanding rendered-site check before publication. Confirm the signed catalog
is approved for publication, its icon pins match these PNGs, and the actual
feed's version/build match the release handoff. Stop on any mismatch.

1. In a new Bash shell, use the existing `site/launcher` checkout. Set
   `SIGNED_PAIR_DIR` to the owner-approved signed pair's directory and
   `RELEASE_DIR` to the owner-approved DMG/appcast directory. The prompts below
   accept paths, not credentials. They do not use the unapproved current root
   pair automatically. Check `git status` is clean and reports `site/launcher`.
   The publication branch is `main` according to this site's README; confirm
   that Pages configuration with the owner before the first future push.

   ```bash
   bash
   set -euo pipefail
   cd /Users/kudige/Developer/GamePacSite-launcher
   git status --short --branch
   read -r -p 'Approved signed catalog directory: ' SIGNED_PAIR_DIR
   read -r -p 'Approved launcher DMG and appcast directory: ' RELEASE_DIR
   RELEASE_CHECK="$(mktemp -d /private/tmp/gamepac-release-check.XXXXXX)"
   trap 'rm -rf "$RELEASE_CHECK"' EXIT
   export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
   export CLANG_MODULE_CACHE_PATH="$RELEASE_CHECK/module-cache"
   VERIFIER=/Users/kudige/Developer/GamePac/scripts/verify-signature.swift
   swift "$VERIFIER" "$SIGNED_PAIR_DIR/catalog.json" "$SIGNED_PAIR_DIR/catalog.json.sig"
   cp "$SIGNED_PAIR_DIR/catalog.json" ./catalog.json
   cp "$SIGNED_PAIR_DIR/catalog.json.sig" ./catalog.json.sig
   cmp "$SIGNED_PAIR_DIR/catalog.json" ./catalog.json
   cmp "$SIGNED_PAIR_DIR/catalog.json.sig" ./catalog.json.sig
   ```

2. Validate every real appcast enclosure against its supplied DMG and signature,
   and stage the verified DMGs. This extracts existing signatures; it never
   signs or invents one. It checks the new catalog's pins before publication.
   The approved feed itself stays outside the site until the downloads are live.

   ```bash
   python3 - "$RELEASE_DIR" "$RELEASE_CHECK" "$VERIFIER" <<'PY'
   from pathlib import Path
   import hashlib, json, re, shutil, subprocess, sys
   import xml.etree.ElementTree as ET
   release, check = map(Path, sys.argv[1:3])
   verifier = sys.argv[3]
   for game in json.loads(Path('catalog.json').read_bytes())['games']:
       name = game['id']
       assert re.fullmatch(r'[a-z0-9-]+', name), name
       assert game['iconURL'] == f'https://game-pac.com/icons/{name}.png'
       assert hashlib.sha256(Path(f'icons/{name}.png').read_bytes()).hexdigest() == game['iconSHA256'], name
   root = ET.parse(release / 'appcast.xml').getroot()
   enclosures = root.findall('./channel/item/enclosure')
   assert enclosures, 'No real appcast enclosures'
   manifest = []
   for index, enclosure in enumerate(enclosures):
       url = enclosure.attrib['url']
       match = re.fullmatch(r'https://game-pac\.com/downloads/(GamePac-[A-Za-z0-9][A-Za-z0-9._-]*\.dmg)', url)
       assert match, url
       name = match.group(1)
       source = release / name
       assert source.stat().st_size == int(enclosure.attrib['length']), name
       sig = enclosure.attrib['{http://www.andymatuschak.org/xml-namespaces/sparkle}edSignature']
       sig_file = check / f'enclosure-{index}.sig'
       sig_file.write_text(sig)
       subprocess.run(['swift', verifier, str(source), str(sig_file)], check=True)
       target = Path('downloads') / name
       if target.exists():
           assert target.read_bytes() == source.read_bytes(), f'Refusing to replace versioned DMG: {name}'
       else:
           shutil.copyfile(source, target)
       manifest.append(str(target))
   (check / 'downloads.txt').write_text('\n'.join(dict.fromkeys(manifest)) + '\n')
   print('Verified catalog icon pins and all DMG lengths/signatures.')
   PY
   git add -- catalog.json catalog.json.sig
   while IFS= read -r FILE; do git add -- "$FILE"; done < "$RELEASE_CHECK/downloads.txt"
   git diff --cached --check
   git diff --cached --stat
   git commit -m "Host signed launcher catalog and verified installers"
   git push origin HEAD:main
   ```

   This normal push includes the already-reviewed launcher preparation commits.
   Never force it. If `main` has advanced and rejects it, stop and have the
   owner integrate the reviewed work while preserving other agents' changes;
   do not use the dirty `GamePacSite-suki` checkout for that integration.

3. Wait for the successful Pages deployment of that exact commit. Then fetch
   the canonical URLs with no redirect and compare decoded bodies to the
   published local artifacts. Inspect headers: PNG `image/png`, JSON
   `application/json`, and the `.sig` limitation described above. Stop if any
   body differs, any URL is not 200, or the catalog signature fails. This also
   verifies the downloads against the DMGs whose signatures were checked above.

   ```bash
   fetch_exact() {
     local RELATIVE="$1" HTTP_CODE
     mkdir -p "$RELEASE_CHECK/live/$(dirname "$RELATIVE")"
     HTTP_CODE="$(curl --disable --fail --silent --show-error --compressed \
       --proto '=https' --max-redirs 0 --connect-timeout 20 --max-time 300 \
       --dump-header "$RELEASE_CHECK/live/$RELATIVE.headers" \
       --output "$RELEASE_CHECK/live/$RELATIVE" --write-out '%{http_code}' \
       "https://game-pac.com/$RELATIVE")"
     test "$HTTP_CODE" = 200
     rg -i '^(content-type|content-encoding|cache-control|age):' "$RELEASE_CHECK/live/$RELATIVE.headers"
     cmp "$RELATIVE" "$RELEASE_CHECK/live/$RELATIVE"
   }
   fetch_exact catalog.json
   fetch_exact catalog.json.sig
   swift "$VERIFIER" "$RELEASE_CHECK/live/catalog.json" "$RELEASE_CHECK/live/catalog.json.sig"
   for ID in minesweeper dottie tilly suki woozy; do fetch_exact "icons/$ID.png"; done
   shasum -a 256 "$RELEASE_CHECK"/live/icons/*.png
   while IFS= read -r FILE; do fetch_exact "$FILE"; done < "$RELEASE_CHECK/downloads.txt"
   ```

4. Only after step 3 passes, copy and publish the actual appcast. Compare the
   feed with the same approved version/build/URL/length/signature metadata
   checked in step 2; every enclosure must already be live and verified. If
   any release source changed since validation, repeat validation first.

   ```bash
   cp "$RELEASE_DIR/appcast.xml" updates/gamepac/appcast.xml
   cmp "$RELEASE_DIR/appcast.xml" updates/gamepac/appcast.xml
   git add -- updates/gamepac/appcast.xml
   git diff --cached --check
   git diff --cached --stat
   git commit -m "Publish verified Game Pac launcher update feed"
   git push origin HEAD:main
   ```

   Wait for this exact Pages deployment, then run:

   ```bash
   fetch_exact updates/gamepac/appcast.xml
   ```

   Expect XML content type (`application/xml` or `text/xml`), status 200,
   no redirect and exact bytes. Verify the launcher's actual update check
   against the live feed before declaring its update channel working.

5. Edit only the `LAUNCHER RELEASE` block documented above, using the real
   verified enclosure URL and version. Keep macOS 14.0 requirements. Verify
   the rendered light/dark desktop and mobile states and the actual download.
   Then publish the reviewed activation:

   ```bash
   git add -- index.html
   git diff --cached --check
   git diff --cached -- index.html
   git commit -m "Enable verified Game Pac launcher download"
   git push origin HEAD:main
   ```

   Wait for that commit's deployment and recheck the live page, download,
   catalog signature, all icon hashes and launcher update channel. Keep older
   versioned downloads referenced by published feeds. No public leaderboard
   activation or unrelated game release is part of this procedure.

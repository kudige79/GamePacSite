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

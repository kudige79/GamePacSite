# Game Pac website

The one-page home for the Game Pac collection: Mine Sweeper, Dottie, Tilly,
Suki, and the Game Pac launcher. It is hand-authored HTML and CSS
with no framework, build step, external font, analytics, cookies, or
JavaScript.

## Refresh the assets

Keep `GamePacSite`, `MineSweeper`, `Dottie`, `Tilly`, and `Suki` as sibling
directories under the same `Developer` directory, then run:

```bash
./Scripts/sync-assets.sh
```

From an isolated site clone, point the same deterministic pipeline at the
source repositories explicitly:

```bash
GAMEPAC_DEVELOPER_ROOT=/path/to/Developer ./Scripts/sync-assets.sh
```

The script copies the committed app icons and each title's approved Modern
image, downsamples them for the web, and regenerates the Game Pac mark,
favicon, and social-preview image. It is deterministic and safe to rerun after
source asset changes, including an icon redesign.

It overwrites `assets/` in place. Rerun it whenever a game's committed icon or
Modern preview changes, then **commit the files it rewrote** — the site ships
what is committed here, not what the sibling repos currently hold. A game UI
change that is never synced leaves the published page advertising an older
build.

The script synchronizes committed source images; it does not regenerate the
games' own preview suites. Dottie and Tilly each own an off-screen renderer
(`Scripts/render-previews.sh`); Mine Sweeper and Suki instead use reviewed
real-window captures. Suki's sources are its shipping 1024-pixel app icon and
`Suki/docs/marketing/midgame-modern-live.png`, a complete light-Modern Release
window rather than a headless substitute. On the canonical Mac, each renderer's
`--check` mode verifies its entire committed suite byte-for-byte against fresh
staged renders. Output from other environments can differ per-machine and must
not, by itself, be treated as evidence that a committed preview is stale.

Tilly's light Modern midgame fixture uses the renderer's AppKit-hosted path.
The ordinary `ImageRenderer` path gave that one system-material surface a warm
cast the running app never shows; the hosted path preserves the app's neutral
grey. Do not point the site back at a separately rendered replacement.

## Preview locally

Open `index.html` directly in Safari. Every asset, stylesheet, and internal
anchor is a relative URL, so the page renders correctly from a local file, from
a project path, and from the apex domain alike. The canonical and social URLs
described below are the deliberate exceptions.

## Published site

The site is live at <https://game-pac.com/>, served by GitHub Pages from the
`main` branch of `origin` (`github.com/kudige79/GamePacSite`), root folder.
`http://` and `https://www.` both redirect to that canonical apex address.

Publishing is already configured. Three places pin the domain and must move
together if it ever changes:

1. `CNAME` in this directory.
2. The **Settings → Pages** custom-domain field, with **Enforce HTTPS** on.
3. The absolute canonical, `og:url`, `og:image`, and Twitter-card URLs in
   `index.html`.

The social image URL must stay absolute: social crawlers cannot resolve a
relative `og:image`, so a relative value yields a blank link preview. DNS
records for the apex and `www` are recorded in
`../GAMEPAC-GITHUB-PAGES-DOMAIN-SETTINGS.md`.

After publishing, verify the Pages deployment, the HTTP-to-HTTPS redirects,
the certificate for both `game-pac.com` and `www.game-pac.com`, and the social
image before treating the release as complete. After changing social metadata,
re-scrape the URL in the Facebook Sharing Debugger and LinkedIn Post Inspector;
those crawlers may otherwise continue showing a cached preview.

## Downloads and updates

Game Pac is the public distribution surface. Player-facing links must stay on
`game-pac.com`; do not link the page to a game repository or its release page.
The website repository remains public so GitHub Pages can serve the site,
while the game source repositories remain private.

Versioned, signed and notarized DMGs live in `downloads/`. Versioned filenames
are deliberate: they prevent a browser or CDN from serving an older build after
a release. The homepage button for each game must name the current version.
Sparkle feeds live in `updates/<game>/appcast.xml`, and their enclosure URLs
also point to the versioned files on `game-pac.com`.

After packaging the sibling projects, the collection-wide distribution helper
is:

```bash
./Scripts/sync-downloads.sh
```

The script copies every versioned DMG found in each sibling project's `dist/`
directory, copies its appcast, rewrites the copied enclosure URLs to
`https://game-pac.com/downloads/`, and refuses to publish an appcast that still
depends on a private game repository. It also verifies that every rewritten
enclosure has a corresponding DMG on the site.

The helper knows all four titles. For Suki's first release, its signed DMG and
appcast were staged title-by-title rather than through this helper, so stale
sibling `dist/` directories could not replace already-hosted files. The
`./downloads/Suki-1.0.0.dmg` card link, the DMG at that path, and
`updates/suki/appcast.xml` must publish together.

Once every title has current local distribution artifacts, use this
collection-wide workflow for each established-title release:

1. Build, sign, notarize and verify the versioned DMG in the game repository.
2. Generate its signed appcast.
3. Run `./Scripts/sync-downloads.sh` here.
4. Update that game's homepage button to the new versioned filename.
5. Commit the DMG, appcast and HTML change together; deploy and verify both URLs.
6. Keep old versioned DMGs that are still referenced by a published appcast.

### Private source and legacy updater compatibility

The three established titles with legacy feeds are freeware, not open source.
Their complete source and history live in private `*-source` repositories. The
exact original repository addresses remain public only as permanent,
source-free compatibility relays because older installed builds have those
URLs embedded.

Each of those three relays has fresh history, a short README pointing players to
`https://game-pac.com`, and one frozen release asset named `appcast.xml`. It
contains no source and no DMG. That appcast offers only the migration build and
downloads its installer from this website. Never delete, replace or privatize a
relay: a Mac that has been offline for years must still be able to cross the
bridge.

The migration build switches to the canonical feed under `updates/`. A later
verification build is advertised only there, proving the second updater hop no
longer depends on the relay. For a bridge release, publish and verify the site
DMG and canonical site appcast first; publish the frozen relay appcast last.

## Game Pac launcher — released

The `#launcher` section uses the launcher's approved ARCADE previews and links
the released app: Game Pac version 1.0.0, build 2, released 2026-09-09, at
<https://game-pac.com/downloads/GamePac-1.0.0.dmg>. The four individually
released games remain linked; Shatranj is coming soon.

**Release edit point:** in `index.html`, find `<!-- LAUNCHER RELEASE:` and edit
only the block through `<!-- END LAUNCHER RELEASE -->` for each new launcher
release:

1. Point the download anchor's `href` at the new verified DMG URL, keeping its
   classes, `download`, and `aria-describedby`.
2. Update the version in `#launcher-release-status`.
3. Keep the macOS requirements line current.

Verify the URL and rendered light/dark download state before publishing.
Navigation and surrounding copy are evergreen; no redesign or JavaScript is
needed to update the block.

To refresh **only** the launcher screenshots from read-only source previews:

```bash
zsh Scripts/sync-launcher-assets.sh
```

Override `GAMEPAC_PREVIEW_DIR` if the source `GamePac/Previews` lives elsewhere.
The script reads `clubhouse-arcade.png`, `clubhouse-states-arcade.png`, and
`clubhouse-detail-arcade.png`; it never regenerates or changes source files.
It exports JPEGs at quality 82, 1440 px wide for the overview and 1100 px for
supporting images, each capped at 300 KiB. Existing game assets are untouched.
The screenshot versions and failure/system-requirement states are illustrative
preview fixtures, not current download metadata.

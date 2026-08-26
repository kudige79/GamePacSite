# Game Pac website

The one-page home for the Game Pac collection: Mine Sweeper, Dottie, Tilly,
and the forthcoming Game Pac launcher. It is hand-authored HTML and CSS with no
framework, build step, external font, analytics, cookies, or JavaScript.

## Refresh the assets

Keep `GamePacSite`, `MineSweeper`, `Dottie`, and `Tilly` as sibling directories
under the same `Developer` directory, then run:

```bash
./Scripts/sync-assets.sh
```

The script copies the committed app icons and Modern-theme preview renders,
downsamples them for the web, and regenerates the Game Pac mark, favicon, and
social-preview image. It is deterministic and safe to rerun after source asset
changes, including an icon redesign.

It overwrites `assets/` in place. Rerun it whenever a game's committed icon or
Modern preview changes, then **commit the files it rewrote** — the site ships
what is committed here, not what the sibling repos currently hold. A game UI
change that is never synced leaves the published page advertising an older
build.

The script synchronizes committed source images; it does not regenerate the
games' own preview suites. Dottie and Tilly each own an off-screen renderer
(`Scripts/render-previews.sh`); Mine Sweeper has none, so its source is a
reviewed real-screen capture. On the canonical Mac, each renderer's `--check`
mode verifies its entire committed suite byte-for-byte against fresh staged
renders. Output from other environments can differ per-machine and must not, by
itself, be treated as evidence that a committed preview is stale.

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
The website repository remains public so GitHub Pages can serve the site, while
the three game source repositories can be private after the updater migration
described below is complete.

Versioned, signed and notarized DMGs live in `downloads/`. Versioned filenames
are deliberate: they prevent a browser or CDN from serving an older build after
a release. The homepage button for each game must name the current version.
Sparkle feeds live in `updates/<game>/appcast.xml`, and their enclosure URLs
also point to the versioned files on `game-pac.com`.

After packaging all three sibling projects, refresh the distribution files with:

```bash
./Scripts/sync-downloads.sh
```

The script copies every versioned DMG found in each sibling project's `dist/`
directory, copies its appcast, rewrites the copied enclosure URLs to
`https://game-pac.com/downloads/`, and refuses to publish an appcast that still
depends on a private game repository. It also verifies that every rewritten
enclosure has a corresponding DMG on the site.

For each game release:

1. Build, sign, notarize and verify the versioned DMG in the game repository.
2. Generate its signed appcast.
3. Run `./Scripts/sync-downloads.sh` here.
4. Update that game's homepage button to the new versioned filename.
5. Commit the DMG, appcast and HTML change together; deploy and verify both URLs.
6. Keep old versioned DMGs that are still referenced by a published appcast.

### Private-repository migration

The builds released on 2026-08-26 still contain legacy Sparkle feed URLs hosted
by their public game repositories. Do **not** make those repositories private
yet: installed copies would lose automatic updates. First release one migration
build of each game while its repository is public. That build must use the
matching `https://game-pac.com/updates/<game>/appcast.xml` feed, and the release
appcast must offer that build to existing installations. After the migration
updates have been live long enough for existing players to receive them, the
three game repositories can be made private without affecting website downloads
or subsequent updates.

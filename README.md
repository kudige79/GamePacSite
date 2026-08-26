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

## Release links

- Mine Sweeper, Dottie, and Tilly use verified permanent
  `releases/latest/download` links. Each title's release page and unversioned DMG
  were live when last checked on 2026-08-26. Their packaging scripts produce the
  unversioned assets needed to keep those URLs stable across releases.

**Every future release of every title must upload the unversioned `<Name>.dmg`
alongside its versioned DMG.** The packaging scripts stage that permanent-link
asset, but uploading it is manual. If a latest release omits the unversioned
copy, the website's primary Download button immediately becomes a 404.

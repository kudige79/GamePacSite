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
social-preview image. It is deterministic and safe to rerun after any source
asset changes, including Tilly's icon redesign.

The script synchronizes committed source images; it does not regenerate the
games' own preview suites. Mine Sweeper currently has no off-screen renderer.
On the canonical Mac, Tilly's renderer verifies all 30 committed previews
byte-for-byte against fresh staged renders. Renders from other environments can
differ per-machine and must not be treated as evidence that those previews are
stale.

## Preview locally

Open `index.html` directly in Safari. Every site-owned URL is relative, so the
same files also work from a GitHub Pages project path.

## Publish with GitHub Pages

1. Create an empty GitHub repository for this directory.
2. Add that repository as the local `origin`, then push the `main` branch.
3. In the repository's **Settings → Pages**, choose **Deploy from a branch**,
   then select the `main` branch and the `/ (root)` folder.

Publishing and remote setup belong to the owner; this project intentionally has
no configured remote.

After GitHub Pages publishes the site, replace the relative `og:image` value in
`index.html` with the page's absolute URL:

```text
https://<user>.github.io/<repo>/assets/og-game-pac.png
```

Social crawlers require that absolute URL; the relative value is only a
pre-publication placeholder.

## Release links

- Mine Sweeper and Dottie use verified permanent `releases/latest/download`
  links. Their packaging scripts produce the unversioned assets needed to keep
  those URLs stable across releases.
- Tilly's permanent Download URL is already wired into the page. It will return
  404 until the owner publishes Tilly's first release with `Tilly.dmg`; its
  release-notes link is intentionally omitted until that page exists. After the
  first release is live, remove the page's "First release landing shortly."
  small print at the same time.

**Every future release of every title must upload the unversioned `<Name>.dmg`
alongside its versioned DMG.** The packaging scripts stage that permanent-link
asset, but uploading it is manual. If a latest release omits the unversioned
copy, the website's primary Download button immediately becomes a 404.

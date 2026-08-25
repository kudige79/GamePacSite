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
games' own preview suites. Mine Sweeper currently has no off-screen renderer,
and Tilly's committed previews did not match a fresh renderer check on
2026-08-25. Review refreshed game previews in their source repos before treating
an asset sync as proof that the underlying capture is current.

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

## Release links

- Mine Sweeper and Dottie use verified permanent `releases/latest/download`
  links. Their packaging scripts produce the unversioned assets needed to keep
  those URLs stable across releases.
- Tilly's permanent Download URL is already wired into the page. It will return
  404 until the owner publishes Tilly's first release with `Tilly.dmg`.

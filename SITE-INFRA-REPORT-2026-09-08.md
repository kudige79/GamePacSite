# Launcher site infrastructure report — 2026-09-08

Worktree: `/Users/kudige/Developer/GamePacSite-launcher`.
Branch: `site/launcher`.
Starting revision: `5e3fa90cdf5a796fedb29d74dc1301441a9816c5`.
This report accompanies the local infrastructure commit; its final SHA is
reported in the handoff. Nothing was pushed, fetched or deployed.

## Added

- Five exact original PNGs under root `icons/`, including unreleased Woozy.
- Empty root `.nojekyll` to disable Pages' default Jekyll processing.
- Narrow `.gitattributes` rules preserving the catalog pair and icon bytes.
- `updates/gamepac/README.md` reserving the launcher's update directory.
- A runtime-infrastructure appendix in `LAUNCHER-PREPARATION.md`, with the
  future artifact paths, a single runnable published-catalog verification
  command, and the owner's complete publication sequence.

No catalog/signature pair, launcher appcast or launcher DMG was added.
The launcher download remains disabled. Existing HTML, CSS, marketing assets,
scripts, downloads, four title feeds, README and CNAME are unchanged.

## Full SHA-256 comparison

Source PNG bytes and site PNG bytes were compared directly. Every digest below
also matches `iconSHA256` in the read-only GamePac catalog.

| Icon | GamePac catalog pin (also source SHA-256) | Site PNG SHA-256 | Result |
| --- | --- | --- | --- |
| minesweeper | `714ffb68094ab855d037c558b006c306dae2235525463dc2bb79f3b7cd7f0b58` | `714ffb68094ab855d037c558b006c306dae2235525463dc2bb79f3b7cd7f0b58` | MATCH |
| dottie | `1635d294f402234e5948e9fc7ad8dafd60c40a306dc502b5148a7e9deab9ab88` | `1635d294f402234e5948e9fc7ad8dafd60c40a306dc502b5148a7e9deab9ab88` | MATCH |
| tilly | `4798d48fd68c32efa5ad8915b40f856e56e736a2774cd216b7e4af28da36a705` | `4798d48fd68c32efa5ad8915b40f856e56e736a2774cd216b7e4af28da36a705` | MATCH |
| suki | `e8a2966c534ab4775440dfae8e01c9b704fd11d839e830fe81fadf2a31300050` | `e8a2966c534ab4775440dfae8e01c9b704fd11d839e830fe81fadf2a31300050` | MATCH |
| woozy | `214a8ba184eb2082667bcdb9ab4eda2eab06ed1646a7e0638eeb2c407506dfd0` | `214a8ba184eb2082667bcdb9ab4eda2eab06ed1646a7e0638eeb2c407506dfd0` | MATCH |

The required `shasum -a 256 icons/*.png` command passed. No optimization,
resizing, re-encoding or metadata stripping was performed.

## Validation and limits

Passed:

- All five source/site byte comparisons and catalog SHA-256 pins.
- Empty `.nojekyll`; absent pending catalog/signature, launcher appcast and DMG.
- Existing page: 23 local file references resolve (19 distinct files);
  19 fragment links, six ARIA references and 15 unique IDs pass.
- Balanced explicit HTML tags, no duplicate attributes, one H1 and no
  skipped heading levels; launcher button remains natively disabled.
- Four existing appcasts parse, with all 14 referenced DMGs present and their
  declared lengths matching actual bytes.
- All three existing shell scripts pass `zsh -n`. Their fixed output paths
  exclude root runtime icons, the catalog pair and the launcher feed.
- All seven documented Bash blocks pass syntax checks; embedded Python
  compiles. Read-only review found no P0/P1/P2 defects in these additions.
- Working and staged diffs show existing site/rendering files and releases
  unchanged; `git diff --check` and staged equivalent pass.

The site has no build/test runner. No signature verification of a real future
catalog or launcher DMG was claimed or attempted. The publication commands
were syntax-checked, not executed.

**Rendered verification remains unverified.** Computer Use returned “No browser
is available”; Safari access returned “Computer Use was not approved to use
Safari”. Automatic approval review rejected Safari access without giving
another reason. No screenshot, browser layout, responsive rendering or visual
regression result is claimed. Static checks and unchanged rendering files
do not replace that required visual proof.

## GitHub Pages behavior

The prepared source has no byte-rewriting build step; `.nojekyll` explicitly
disables Jekyll. Existing asset tooling only transforms marketing assets in
`assets/`, so no additional exclusion was needed.
[GitHub Pages static-site documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site#static-site-generators)

Pages chooses MIME types and cannot override them per file/repository.
The current `.sig` mapping is `application/pgp-signature`, an inaccurate
format label for this detached Ed25519 signature. The brief's strict
content-type requirement therefore cannot be fully guaranteed on the current
host. The label does not change the signature bytes. Actual live MIME headers,
status 200 and absence of redirects must be checked after owner publication.
[Pages MIME policy](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site#mime-types-on-github-pages),
[mime-db](https://github.com/jshttp/mime-db/blob/master/db.json)

Lossless HTTP compression preserves decoded content bytes. Caches may supply
older catalog/signature generations or cached misses; they do not imply JSON
rewriting. Publishing the pair together is necessary but cannot guarantee
atomic visibility at every cache. The owner must compare exact downloaded
bodies and verify the signature at the canonical URLs. No fixed cache TTL is
claimed.
[HTTP content codings](https://www.rfc-editor.org/rfc/rfc9110.html#section-8.4.1),
[HTTP caching](https://www.rfc-editor.org/rfc/rfc9111.html#section-4.2)

## Exact owner publication procedure

The complete runnable sequence is in
[LAUNCHER-PREPARATION.md — Owner-only future publication sequence](LAUNCHER-PREPARATION.md#owner-only-future-publication-sequence);
the independent one-command catalog check immediately precedes it. It uses
the existing read-only CryptoKit verifier, never a signing key.

1. Obtain and review the actual signed catalog pair, notarized launcher DMGs
   and generated feed; complete the rendered-site check.
2. On a clean `site/launcher`, verify/copy the approved pair, verify the catalog
   icon pins and every real feed enclosure's local length/signature, then stage
   those exact versioned DMGs.
3. Commit the pair and DMGs and, only when the owner chooses to publish, run
   the documented normal `git push origin HEAD:main`. Stop on rejection and
   have the owner reconcile advanced main; never force or use the dirty sibling.
4. Wait for the exact Pages deployment; require no-redirect HTTPS 200, inspect
   content types, compare all five live PNGs, both catalog files and all DMGs
   byte-for-byte with the intended release; verify the live catalog signature.
5. Only then copy/commit/publish the actual `updates/gamepac/appcast.xml`.
   Wait for deployment; verify exact live feed bytes and real launcher update
   behavior against its already verified enclosure(s).
6. Activate only the existing HTML release block with the real version and
   verified URL; check light/dark desktop/mobile rendering and the download,
   commit/publish, then recheck live release behavior.

None of those publication operations was run for this task.

## Sibling isolation

The only direct operation performed against
`/Users/kudige/Developer/GamePacSite-suki` was `git status`.
Its complete before/after status output is byte-identical. No GamePac source
file was changed; source access was read-only. Local staging/commit is performed
only through the authorized launcher worktree.

Before:

```text
On branch codex/leaderboards
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
	modified:   index.html
	modified:   style.css

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	Tests/
	leaderboards/
	privacy.html

no changes added to commit (use "git add" and/or "git commit -a")
```

After:

```text
On branch codex/leaderboards
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
	modified:   index.html
	modified:   style.css

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	Tests/
	leaderboards/
	privacy.html

no changes added to commit (use "git add" and/or "git commit -a")
```

## Implementation notes

Kimi was attempted first using a bounded brief. It exited 1 before implementation
with `storage write failed: permission denied`, plus `EMFILE: too many open
files, watch`. Codex implemented the authorized fallback and independently
verified it. Temporary implementation brief/log files were removed after these
notes were consolidated into this report.

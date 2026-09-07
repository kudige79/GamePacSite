# Game Pac launcher update channel

This directory reserves `https://game-pac.com/updates/gamepac/appcast.xml`.
There is intentionally no appcast here until the real release exists.

The owner-generated `GamePac/dist/appcast.xml` belongs at `appcast.xml` in
this directory. First publish every versioned DMG it references under the
site's root `downloads/` directory and verify the live HTTPS responses,
exact bytes, lengths and Sparkle signatures. Only then publish the feed.
Never invent an enclosure URL, version, signature or empty placeholder feed.

Follow the owner-only publication sequence in
[`LAUNCHER-PREPARATION.md`](../../LAUNCHER-PREPARATION.md).

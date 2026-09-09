# Game Pac launcher update channel

This directory holds `appcast.xml`, the Game Pac launcher's live Sparkle feed
at `https://game-pac.com/updates/gamepac/appcast.xml`.

Before the feed changes, every enclosure must already be live under the site's
root `downloads/` directory and verified over HTTPS for exact bytes, lengths
and Sparkle signatures. Never remove published items or replace the feed with
a placeholder.

Follow the publication sequence in
[`LAUNCHER-PREPARATION.md`](../../LAUNCHER-PREPARATION.md).

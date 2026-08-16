<div align="center">
  <h1>koto-cli</h1>
  <p><strong>Watch anime from your terminal.</strong></p>

  <p>
    <a href="https://github.com/VVAT3R/koto-cli">GitHub</a> •
    <a href="https://github.com/VVAT3R/koto-cli/issues">Issues</a>
  </p>

  <p>
    <img src="https://img.shields.io/badge/license-GPLv3-blue" alt="License">
    <img src="https://img.shields.io/badge/shell-POSIX-green" alt="POSIX">
  </p>
</div>

---

A standalone POSIX shell script to browse, search and watch anime from the command-line, inspired by [pystardust/ani-cli](https://github.com/pystardust/ani-cli). It scrapes **anikototv.to** for direct HLS streams — no crypto dependencies.

### How koto-cli came to be

koto-cli started as a fork of ani-cli whose provider didn't serve some anime that were missing from anidb.app — now the new default provider of upstream ani-cli — so I couldn't watch what I wanted to. So I reverse-engineered [anikototv.to](https://anikototv.to), inspecting its network requests, HTML and scripts in the browser devtools, and wrote an **anikoto** provider on top of ani-cli's structure. That work lived on the `ani-cli-anikoto` branch, and I spun it out into this standalone repo so it can live on its own, with no ties to ani-cli. It's still at an experimental stage — expect rough edges.

The whole pipeline runs in plain POSIX shell — no API keys, no crypto, no python3:

1. **Search** hits the site's `ajax/anime/search?keyword=...` endpoint (with an `X-Requested-With: XMLHttpRequest` header) and regexes the returned HTML into `slug` + title pairs.
2. **Anime ID** is read from the watch page's `id="watch-main" data-id="..."` attribute (falling back to the `mangaId = ...` script variable) and cached so it's fetched only once per title.
3. **Episodes** come from `ajax/episode/list/<id>` — `data-num` attributes yield the episode numbers, `data-ids` links them to their server groups.
4. **Servers** are resolved via `ajax/server/list?servers=<ids>`. Each entry has a `data-type` (**hsub** = hard subs, **sub** = soft subs, **dub**) and a `data-link-id`. koto-cli asks for `hsub` by default and `dub` with `--dub`; if no hard-sub servers exist for an episode it falls back to soft-sub (`sub`) servers and hands the player the episode's English caption track. If the server list comes back empty, it pings `/check-server` once to force the site to refresh the links.
5. **Streams**: each server resolves to a megaplay embed (`ajax/server?get=<link-id>`). koto-cli grabs the `#megaplay-player` `data-id`, then calls `<host>/stream/getSources?id=<file-id>&type=<type>` for the `.m3u8`. Direct-playable hosts (vidtube, akirax) are tried first, proxied ones second.
6. **Feeder**: the m3u8 segments are obfuscated — real MPEG-TS with a junk prefix. koto-cli auto-detects the prefix by scanning for the TS sync byte `0x47` repeated every 188 bytes, then a pure-POSIX background feeder downloads each segment, strips the junk, and writes clean `.ts` files into a local cache dir that the player reads from a local `playlist.m3u8` (FIFOs for download flow control, regular files so mpv can seek back).

### Features

- **anikoto** source — direct `.m3u8` streams, no crypto dependencies
- Hard-sub (hsub) and dubbed playback, with soft-sub (caption) fallback when a title has no hard subs
- Watch history with resume position tracking (`-c`, `--resume`)
- Batch download with progress indicator (`--batch`)
- Single & multi-episode selection, including ranges (`-e`, `-r`)
- Quality selection (`-q`)
- Interactive menus (fzf / rofi / dmenu)
- Jump between seasons of a show from the post-play menu
- Skip intros with ani-skip (`--skip`, mpv only)
- Player support: mpv, vlc, iina, android, flatpak, syncplay and more
- Next-episode countdown (`-N`)
- Install & uninstall scripts included

### Quick start

```sh
curl -fsSL https://raw.githubusercontent.com/VVAT3R/koto-cli/main/install.sh | sudo sh
```

### Usage

```sh
koto-cli [options] [query]
```

Run `koto-cli -h` for the full list of options.

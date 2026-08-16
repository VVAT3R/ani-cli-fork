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

### Features

- **anikoto** source — direct `.m3u8` streams, no crypto dependencies
- Sub and dub playback
- Watch history with resume position tracking
- Batch download with progress indicator
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

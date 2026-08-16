#!/bin/sh
set -e

REPO="VVAT3R/ani-cli-fork"
BRANCH="ani-cli-anikoto"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

if echo "$PREFIX" | grep -q "com.termux"; then
    INSTALL_DIR="${ANI_CLI_INSTALL_DIR:-/data/data/com.termux/files/usr/bin}"
else
    INSTALL_DIR="${ANI_CLI_INSTALL_DIR:-/usr/local/bin}"
fi

printf "\033[1;34mInstalling ani-cli from %s...\033[0m\n" "$REPO"

command -v curl >/dev/null || { printf "\033[1;31mError: curl not found\033[0m\n"; exit 1; }

_tmpdir="$(mktemp -d)"
trap 'rm -rf "$_tmpdir"' EXIT

printf "Downloading ani-cli...\n"
curl -fsSL "${RAW}/ani-cli" -o "${_tmpdir}/ani-cli" || { printf "\033[1;31mFailed to download ani-cli\033[0m\n"; exit 1; }
chmod +x "${_tmpdir}/ani-cli"

printf "Installing to %s...\n" "$INSTALL_DIR"
install -d "${INSTALL_DIR}"
install -m 755 "${_tmpdir}/ani-cli" "${INSTALL_DIR}/ani-cli"

printf "\033[1;32mani-cli installed successfully!\033[0m\n"
printf "  Binary:  %s/ani-cli\n" "$INSTALL_DIR"
printf "\nRun: ani-cli --help\n"

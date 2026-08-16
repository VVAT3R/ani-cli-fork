#!/bin/sh
set -e

REPO="VVAT3R/koto-cli"
BRANCH="main"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

if echo "$PREFIX" | grep -q "com.termux"; then
    INSTALL_DIR="${KOTO_CLI_INSTALL_DIR:-/data/data/com.termux/files/usr/bin}"
else
    INSTALL_DIR="${KOTO_CLI_INSTALL_DIR:-/usr/local/bin}"
fi

printf "\033[1;34mInstalling koto-cli from %s...\033[0m\n" "$REPO"

command -v curl >/dev/null || { printf "\033[1;31mError: curl not found\033[0m\n"; exit 1; }

_tmpdir="$(mktemp -d)"
trap 'rm -rf "$_tmpdir"' EXIT

printf "Downloading koto-cli...\n"
curl -fsSL "${RAW}/koto-cli" -o "${_tmpdir}/koto-cli" || { printf "\033[1;31mFailed to download koto-cli\033[0m\n"; exit 1; }
chmod +x "${_tmpdir}/koto-cli"

printf "Installing to %s...\n" "$INSTALL_DIR"
install -d "${INSTALL_DIR}"
install -m 755 "${_tmpdir}/koto-cli" "${INSTALL_DIR}/koto-cli"

printf "\033[1;32mkoto-cli installed successfully!\033[0m\n"
printf "  Binary:  %s/koto-cli\n" "$INSTALL_DIR"
printf "\nRun: koto-cli --help\n"

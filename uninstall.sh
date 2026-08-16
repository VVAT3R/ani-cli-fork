#!/bin/sh
set -e

if echo "$PREFIX" | grep -q "com.termux"; then
    INSTALL_DIR="${KOTO_CLI_INSTALL_DIR:-/data/data/com.termux/files/usr/bin}"
else
    INSTALL_DIR="${KOTO_CLI_INSTALL_DIR:-/usr/local/bin}"
fi

printf "\033[1;34mUninstalling koto-cli...\033[0m\n"

_removed=0

_path="${INSTALL_DIR}/koto-cli"
if [ -f "$_path" ] || [ -L "$_path" ]; then
    rm -f "$_path"
    printf "  Removed %s\n" "$_path"
    _removed=1
fi

if [ "$_removed" -eq 0 ]; then
    printf "\033[1;31mkoto-cli not found in %s\033[0m\n" "$INSTALL_DIR"
    exit 1
fi

printf "\033[1;32mkoto-cli uninstalled successfully!\033[0m\n"

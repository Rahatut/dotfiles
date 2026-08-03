#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE="$SCRIPT_DIR/../niri/niri.desktop"
SYSTEM_DIR="/usr/share/wayland-sessions"
USER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/wayland-sessions"

TARGET_DIR="$SYSTEM_DIR"
if [ "${1:-}" = "--user" ]; then
    TARGET_DIR="$USER_DIR"
fi

TARGET="$TARGET_DIR/niri.desktop"

if [ ! -f "$SOURCE" ]; then
    printf 'missing source file: %s\n' "$SOURCE" >&2
    exit 1
fi

if [ "$TARGET_DIR" = "$SYSTEM_DIR" ] && [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        sudo install -Dm644 "$SOURCE" "$TARGET"
    else
        printf 'need root or sudo to install %s\n' "$TARGET" >&2
        exit 1
    fi
else
    install -Dm644 "$SOURCE" "$TARGET"
fi

printf 'installed %s\n' "$TARGET"
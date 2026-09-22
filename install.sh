#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != Darwin ]]; then
    printf '%s\n' 'air-sweep requires macOS.' >&2
    exit 1
fi

REPO="${AIR_SWEEP_REPO:-navsam2917/air-sweep}"
REF="${AIR_SWEEP_REF:-main}"
BASE_URL="${AIR_SWEEP_BASE_URL:-https://raw.githubusercontent.com/$REPO/$REF}"
PLUGIN_DIR="${SWIFTBAR_PLUGIN_DIR:-$HOME/.swiftbar-plugins}"

if ! command -v curl >/dev/null 2>&1; then
    printf '%s\n' 'air-sweep requires curl.' >&2
    exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' 'Homebrew is required to install SwiftBar. Install it from https://brew.sh first.' >&2
    exit 1
fi

if [[ ! -d /Applications/SwiftBar.app ]]; then
    printf '%s\n' 'SwiftBar not found; installing it with Homebrew.'
    brew install --cask swiftbar
fi

mkdir -p "$PLUGIN_DIR/bin"
curl -fsSL "$BASE_URL/air-sweep.1h.sh" -o "$PLUGIN_DIR/air-sweep.1h.sh"
curl -fsSL "$BASE_URL/bin/air-sweep" -o "$PLUGIN_DIR/bin/air-sweep"
chmod 755 "$PLUGIN_DIR/air-sweep.1h.sh" "$PLUGIN_DIR/bin/air-sweep"

defaults write com.ameba.SwiftBar PluginDirectory "$PLUGIN_DIR"
printf '%s\n' "Installed air-sweep to $PLUGIN_DIR"
printf '%s\n' 'Start or restart SwiftBar, then look for air-sweep in the menu bar.'
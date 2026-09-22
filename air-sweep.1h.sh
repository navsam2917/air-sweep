#!/usr/bin/env bash

# <bitbar.title>air-sweep</bitbar.title>
# <bitbar.version>v1.0.0</bitbar.version>
# <bitbar.author>air-sweep contributors</bitbar.author>
# <bitbar.desc>Audit and safely purge developer caches on macOS.</bitbar.desc>
# <bitbar.dependencies>bash, swiftbar</bitbar.dependencies>

set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CLI="${AIR_SWEEP_CLI:-$SCRIPT_DIR/bin/air-sweep}"
HOME_DIR=${HOME:?HOME must be set}
WA_MEDIA="$HOME_DIR/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/Message/Media"
CURSOR_DB="$HOME_DIR/Library/Application Support/Cursor/User/globalStorage/state.vscdb"
UV_CACHE=${UV_CACHE_DIR:-"$HOME_DIR/.cache/uv"}
USER_CACHES="$HOME_DIR/Library/Caches"

if [ "${1:-}" = clean ]; then
    exec "$CLI" clean "${2:-}" --yes
fi

get_size() {
    if [ -e "$1" ] || [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | awk '{print $1}'
    else
        printf '0B\n'
    fi
}

if [ "$(uname -s)" != Darwin ]; then
    printf '%s | macOS only\n' "air-sweep"
    exit 0
fi

FREE_RAW=$(df -H / | awk 'NR == 2 { print $4 }')
printf '%s | %s free\n' "air-sweep" "${FREE_RAW:-unknown}"
echo '---'
printf '%s | color=#888888\n' "Live storage audit"
printf '%s | %s\n' "-- WhatsApp media" "$(get_size "$WA_MEDIA")"
printf '%s | %s\n' "-- Cursor state DB" "$(get_size "$CURSOR_DB")"
printf '%s | %s\n' "-- uv wheel cache" "$(get_size "$UV_CACHE")"
printf '%s | %s\n' "-- App caches" "$(get_size "$USER_CACHES")"
echo '---'
echo 'Safe actions | bold=true'
printf '%s\n' "Purge WhatsApp media | bash='$0' param1=clean param2=whatsapp terminal=false refresh=true"
printf '%s\n' "Reset Cursor state DB | bash='$0' param1=clean param2=cursor terminal=false refresh=true"
printf '%s\n' "Clean uv and npm caches | bash='$0' param1=clean param2=devtools terminal=false refresh=true"
printf '%s\n' "Clean macOS app caches | bash='$0' param1=clean param2=app-caches terminal=false refresh=true"
echo '---'
printf '%s\n' "Wipe all ephemeral bloat | bash='$0' param1=clean param2=all terminal=false refresh=true color=#FF4444"
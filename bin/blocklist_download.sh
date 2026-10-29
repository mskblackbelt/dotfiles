#!/usr/bin/env bash
#
# Build a Transmission blocklist from the free lists on iblocklist.com
# Usage: blocklist_download.sh [output-file]
set -uo pipefail

out="${1:-/Volumes/Airlock/Torrents/transmission_blocklist.txt}"

curl -fsS -A "Mozilla/5.0" https://www.iblocklist.com/lists.php \
	| grep -oE "http://list\.iblocklist\.com/\?list=[a-z]+&amp;fileformat=p2p&amp;archiveformat=gz" \
	| sed 's/&amp;/\&/g' | sort -u \
	| while read -r url; do
		curl -fsSL "$url" | gunzip 2>/dev/null || echo "Skipped $url" >&2
	done \
	| grep -Ev '^(#|$)' > "$out"

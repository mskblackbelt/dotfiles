#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

TMPFILE=/tmp/downloader-$$

onexit() {
  rm -f $TMPFILE
}

trap onexit EXIT

curl -s "$1" -o $TMPFILE

i=0
grep '<video' $TMPFILE | cut -d\> -f2 | cut -d\< -f1 | while read title; do
  titles[$i]=$title
  ((i++))
done

i=0
grep "watch?" $TMPFILE | cut -d\" -f4 | while read url; do
  urls[$i]="http://www.youtube.com$url"
  ((i++))
done

i=0; while (( i < ${#urls[@]} )); do
  youtube-dl -o "${titles[$i]}.%(ext)" "${urls[$i]}"
  ((i++))
done
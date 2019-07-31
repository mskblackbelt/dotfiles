#!/usr/bin/env bash
#
# Script to convert all Markdown documents in the folder to 
# gradable PDFs using pandoc and my custom grading template. 
# set -euf
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

[[ -d ./to_grade ]] || mkdir -p ./to_grade
mkdir -p ./tmp
for file in *.md; do 
	(filename=$(basename "$file" .md)
	tmpfile="$(mktemp ./tmp/conv.XXXXXXXX)"
	# Use uconv to merge any weird Unicode accents into a single character for LaTeX
	/usr/local/bin/uconv -x any-nfc "$file" > "$tmpfile"
	/usr/local/bin/pandoc -f markdown+link_attributes --template=/Users/mskblackbelt/.pandoc/grading.latex "$tmpfile" \
		-o ./to_grade/"$filename".pdf
	# If file conversion results in an error (RESULT != 0), report the file and move on.
	if [ $? -eq 0 ]; then
		true
	else
		echo "Could not convert $file"
	fi) &
done

wait && trash ./tmp

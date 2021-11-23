curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -s https://www.iblocklist.com/lists.php \
 | sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
 | xargs wget -O - \
 | gunzip \
 | egrep -v '^#' > /Volumes/Airlock/Torrents/transmission_blocklist.txt

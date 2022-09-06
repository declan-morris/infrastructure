#!/bin/bash

d=$(date +%Y%m%d)
echo " starting run on $d"

# get vids that have been uploaded today
#/home/dtm/.local/bin/yt-dlp --dateafter $d --config-location /home/dtm/youtubedl/dl.config https://www.youtube.com/playlist?list=PL1tiwbzkOjQydg3QOkBLG9OYqWJ0dwlxF

# TODO this may download too many videos, need to double check this!
echo  "run youtube downloader for this playlist for videos uploaded in the last two weeks"
/home/dtm/.local/bin/yt-dlp --dateafter today-2weeks --config-location /home/dtm/youtubedl/dl.config https://www.youtube.com/playlist?list=PL1tiwbzkOjQydg3QOkBLG9OYqWJ0dwlxF
# /home/dtm/.local/bin/yt-dlp -I 15:17 --config-location /home/dtm/youtubedl/dl.config https://www.youtube.com/playlist?list=PL1tiwbzkOjQydg3QOkBLG9OYqWJ0dwlxF


echo "get png files for each of the webp files"
DIRECTORY='/storage/data/media/tvshows/Critical Role (2015)/Season 03'
echo $DIRECTORY
cd "$DIRECTORY"

shopt -s nullglob nocaseglob extglob

for FILE in *.@(webp); do 
    #TODO check if png file exists and skip if so
    NEWNAME=$(echo "$FILE" | cut -f 1 -d '.')
    dwebp "$FILE" -o "${NEWNAME%.}.png";
done

# get critical role id in sonarr
id=$(curl --location --request GET 'http://soleria:8989/api/series/lookup?term=tvdb:296861&apikey=45adc9c9af2b44689c4f951300d7ff99' | jq -r '.[0].id')

echo "the show id is: $id"
echo "rescan the series for newly added files"
curl --location --request POST 'http://soleria:8989/api/command?apikey=45adc9c9af2b44689c4f951300d7ff99' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "RescanSeries",
  "seriesID": '"${id}"'
}'

sleep 10

echo
echo "rename the newly added files"
curl --location --request POST 'http://soleria:8989/api/command?apikey=45adc9c9af2b44689c4f951300d7ff99' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "RenameSeries",
  "seriesIds": ['"${id}"']
}'

ls -l "/storage/data/media/tvshows/Critical Role (2015)/Season 03/" | grep webm

echo "finished #####################################"
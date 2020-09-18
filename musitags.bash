#!/bin/bash

# MUSITAGS
#
# Tag your music files based on the folder hierarchy
#

FILENAME=
ARTIST=
GENRE=
ALBUM=
TRACKNO=
TITLE=

getDataFromFilename() {
    FILENAME=$(basename "$1")

    TRACKNO=${FILENAME%%.*}

    ARTIST=${FILENAME#*.}	    # Remove track number
    ARTIST=${ARTIST%-*}	    # Remove file extension and title
    ARTIST=${ARTIST:1:$((${#ARTIST} - 2))}

    TITLE=${FILENAME#*-}	    # Remove track number and artist name
    TITLE=${TITLE%.*}	    # Remove file extension
    TITLE=${TITLE:1}	    # Remove leading space
}

getAlbumFromFolder() {
    ALBUM=${1#*.}
    ALBUM=${ALBUM:1:$((${#ALBUM} - 1))}
}

convertAndTag() {
    lame "$FILENAME" --tt "$TITLE" --ta "$ARTIST" --tl "$ALBUM" --tn $TRACKNO
}

myFunction() {
    echo $1;
}

if [ -f "$1" ]; then
    echo "$1 is a file"
fi
if [ -d "$1" ]; then
    echo "$1 is a directory"
    getAlbumFromFolder "$1"
    cd "$1"
    for file in *; do
	getDataFromFilename "$file"
	convertAndTag
    done
fi


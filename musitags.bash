#!/bin/bash

# MUSITAGS
#
# Tag your music files based on the folder hierarchy
#

FILENAME=
ARTIST="Harris Heller"
GENRE="Lo-Fi"
ALBUM="High At The Planetarium"
TRACKNO=
TITLE=

if [ -f "$1" ]; then
    FILENAME=$(basename "$1")
    echo "$FILENAME is a file"
fi
if [ -d "$1" ]; then
    echo "$1 is a directory"
fi

TRACKNO=${FILENAME%%.*}

ARTIST=${FILENAME#*.}	    # Remove track number
ARTIST=${ARTIST%-*}	    # Remove file extension and title
ARTIST=${ARTIST:1:$((${#ARTIST} - 2))}


TITLE=${FILENAME#*-}	    # Remove track number and artist name
TITLE=${TITLE%.*}	    # Remove file extension
TITLE=${TITLE:1}	    # Remove leading space


lame "$FILENAME" --tt "$TITLE" --ta "$ARTIST" --tn $TRACKNO

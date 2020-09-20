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


processArtistFolder() {
    ARTIST=$1
    cd "$1"

    for genre in *; do
	processGenreFolder "$genre"
    done
    exit
}

processGenreFolder() {
    GENRE=$1
    cd "$1"

    for album in *; do
	processAlbumFolder "$album"
    done
    GENRE=
    cd ..
}

processAlbumFolder() {
    ALBUM=${1#*.}
    ALBUM=${ALBUM:1:$((${#ALBUM} - 1))}
    cd "$album"

    for tune in *; do
	processAudioFile "$tune"
    done
    ALBUM=
    cd ..
}

processAudioFile() {
    FILENAME=$(basename "$1")


    if [ "${FILENAME##*.}" != 'zip' ]; then
	if [ "$2" == '--with-artist' ]; then
	    ARTIST=${FILENAME#*.}   # Remove track number
	    ARTIST=${ARTIST%-*}     # Remove file extension and title
	    ARTIST=${ARTIST:1:$((${#ARTIST} - 2))}
	fi
	
	TITLE=${FILENAME%.*}	    # Remove file extension
	if [[ ${TITLE%.*} != $TITLE ]]; then
	    TRACKNO=${TITLE%.*}	    # Get the track number
	    TITLE=${TITLE#*.}	    # Remove track number
	fi
	if [[ ${TITLE#*-} != $TITLE ]]; then
	    TITLE=${TITLE#*-}	    # Remove artist name
	fi
	
	if [[ ${TITLE:0:1} == ' ' ]]; then
	    TITLE=${TITLE:1}	    # Remove leading space
	fi

	echo Artist: $ARTIST
	echo Genre: $GENRE
	echo Album: $ALBUM
	echo $TRACKNO - $TITLE

	convertAndTag
    fi

    TRACKNO=
    TITLE=
}


convertAndTag() {
    lame "$FILENAME" --tt "$TITLE" --ta "$ARTIST" --tl "$ALBUM" --tn $TRACKNO --tg "$GENRE"
}


if [ -f "$1" ]; then
    echo "$1 is a file"
    processAudioFile "$1" --with-artist
fi
if [ -d "$1" ]; then
    echo "$1 is a directory"

    processArtistFolder "$1"
fi


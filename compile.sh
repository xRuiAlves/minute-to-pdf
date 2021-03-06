#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FILENAME=""
DOWNLOAD_URL=""
OUTFILE=""

while [[ "$#" -gt 0 ]]
do
    case $1 in
        --url)
            DOWNLOAD_URL="$2"
            shift
        ;;
        --out)
            OUTFILE="$2"
            shift
        ;;
        *)
            FILENAME="$1"
        ;;
    esac
    shift
done

if [[ "$DOWNLOAD_URL" == "" ]]; then
    OUTFILE=${OUTFILE:-"${FILENAME%.*}.pdf"}
fi

echo "FILENAME: $FILENAME"
echo "DOWNLOAD_URL: $DOWNLOAD_URL"
echo "OUTFILE: $OUTFILE"

if [[ "$DOWNLOAD_URL" == "" ]]; then
    python3 "$DIR/src/main.py" "$FILENAME" | pandoc -o "$OUTFILE"
else
    if [[ "$OUTFILE" == "" ]]; then
        echo "Missing the output file. Use the option --out <filename> to specify one."
        exit -1
    fi

    curl "$DOWNLOAD_URL/download" | python3 "$DIR/src/main.py" | pandoc -o "$OUTFILE"
fi
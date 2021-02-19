#!/bin/bash

IN_FILE="$1"
OUT_DIR="${1%.*}"
NO_ZIP="${1%.zip}"

if [ "$IN_FILE" = "$OUT_DIR" ]
then
  notify-send -u critical -i error "Unzip Error" "Will not unzip an extensionless file/directory"
  exit 1
fi

if [ ! -e "$IN_FILE" ]
then
  notify-send -u normal -i error "Unzip Error" "File doesn't exist."
  exit 1
fi

MIME_TYPE=`file -b --mime-type "$IN_FILE"`
if [ "$MIME_TYPE" != "application/zip" ]
then
  notify-send -u critical -i error "Unzip Error" "Not a zip file!"
  exit 1
fi

if [ "$IN_FILE" = "$NO_ZIP" ]
then
  notify-send -u low -i important "Unzip Warning" "Not a zip extension."
fi

if [ -e "$OUT_DIR" ]
then
  notify-send -u normal -i error "Unzip Error" "Output directory exists! Aborting..."
  exit 1
fi

mkdir -p "$OUT_DIR"
unzip "$IN_FILE" -d "$OUT_DIR"

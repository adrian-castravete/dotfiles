#!/bin/sh

mogrify -filter Box -resize 200% -format xpm *.png

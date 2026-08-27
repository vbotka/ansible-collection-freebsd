#!/usr/bin/bash

shopt -s globstar

. defaults/batch

# Sanitize files
for i in **/*.orig; do
    d=$(dirname "$i")
    f=$(basename "$i")
    filename="${f%.*}"
    cp "$i" "${d}/${filename}"
done

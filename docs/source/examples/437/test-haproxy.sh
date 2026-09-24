#!/usr/local/bin/bash

for i in $(seq 1 7); do
    curl -s http://172.16.99.1/ | sed -n 's/.*<p>\(.*\)<\/p>.*/\1/p'
done

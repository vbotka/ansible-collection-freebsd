#!/usr/bin/env bash
set -euo pipefail

for _ in {1..7}; do
    curl -s "http://${1}/" | sed -n 's/.*<p>\([^<]*\)<\/p>.*/\1/p'
done

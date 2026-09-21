#!/usr/bin/env bash
# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

set -euo pipefail

# Target collection directory
COLLECTION_DIR="$HOME/.ansible/collections/ansible_collections/vbotka/freebsd"

echo "Navigating to collection directory: $COLLECTION_DIR"
cd "$COLLECTION_DIR"

echo "Installing documentation dependencies..."
python3 -m pip install ansible-core antsibull-docs

echo "Setting Ansible collections path..."
export ANSIBLE_COLLECTIONS_PATH="$HOME/.ansible/collections"

echo "Linting collection documentation..."
antsibull-docs lint-collection-docs --plugin-docs .

echo "Preparing destination directory..."
mkdir -p dest
chmod g-w dest

echo "Initializing Sphinx documentation structure..."
antsibull-docs sphinx-init --use-current --squash-hierarchy vbotka.freebsd --dest-dir dest

echo "Entering destination directory and installing Sphinx requirements..."
cd dest
python3 -m pip install -r requirements.txt

echo "Building documentation..."
./build.sh

echo "Documentation build complete."

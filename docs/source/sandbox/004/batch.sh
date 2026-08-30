#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Configure local pkg-repo
ansible-playbook -i iocage.ini pb-packages.yml | tee out/out-01.txt

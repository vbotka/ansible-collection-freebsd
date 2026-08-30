#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Display iocage properties
ansible-playbook pb-vars-properties.yml -i iocage.yml -l test_133 | tee out/out-01.txt

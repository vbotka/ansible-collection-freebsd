#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Display iocage_* vars
ansible-playbook pb-vars-all.yml -i iocage.yml -l test_133 | tee out/out-01.txt

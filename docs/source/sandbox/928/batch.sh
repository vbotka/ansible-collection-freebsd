#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy template ansible-init
# ssh admin@iocage_06 sudo iocage destroy -f ansible-init

# Create template
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

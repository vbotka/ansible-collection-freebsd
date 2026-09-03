#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Create templates
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Display iocage_* vars
ansible-playbook -i iocage.ini pb-vars-iocage.yml | tee out/out-01.txt

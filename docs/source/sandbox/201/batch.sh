#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Status
ssh admin@iocage_06 sudo iocage list -r | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -P | tee out/out-04.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-06.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt

#
ansible-playbook -i iocage.ini pb-iocage-display-datasets.yml | tee out/out-09.txt

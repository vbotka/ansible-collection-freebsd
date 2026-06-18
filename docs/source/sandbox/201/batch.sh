#!/usr/bin/bash

. ../defaults/batch

# Status
ssh admin@$iocage_05 sudo iocage list -r | tee out/out-02.txt
ssh admin@$iocage_05 sudo iocage list -P | tee out/out-04.txt
ssh admin@$iocage_05 sudo iocage list -lt | tee out/out-06.txt
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-08.txt

#
ansible-playbook pb-iocage-display-datasets.yml -i iocage.ini | tee out/out-09.txt

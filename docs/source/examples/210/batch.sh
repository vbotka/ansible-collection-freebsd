#!/usr/bin/bash

. ../defaults/batch

# Create jail
ssh admin@$iocage_04 sudo iocage create -n test_4 -r 14.3-RELEASE

# List jails
ssh admin@$iocage_04 iocage list -l | tee out/out-01.txt

# Test
ansible-playbook -i iocage.ini pb-iocage.yml | tee out/out-02.txt
ansible-playbook -i hosts pb-test.yml | tee out/out-03.txt

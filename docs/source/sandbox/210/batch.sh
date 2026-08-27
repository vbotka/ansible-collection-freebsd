#!/usr/bin/bash

. ../defaults/batch

# Create jail
ssh admin@iocage_06 sudo iocage create -n test_5 -r 15.1-RELEASE

# List jails
ssh admin@iocage_06 iocage list -l | tee out/out-01.txt

# Test
ansible-playbook -i iocage.ini pb-iocage.yml | tee out/out-02.txt
ansible-playbook -i hosts pb-test.yml | tee out/out-03.txt

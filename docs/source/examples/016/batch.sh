#!/usr/bin/bash

. ../defaults/batch

# status of jails
ssh admin@$iocage_02 iocage list -l | tee out/out-01.txt
ssh admin@$iocage_04 iocage list -l | tee out/out-02.txt

# test
ansible-playbook pb-test.yml -i hosts | tee out/out-03.txt

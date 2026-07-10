#!/usr/bin/bash

. ../defaults/batch

# Status of jails
ssh admin@iocage_06 iocage list -l | tee out/out-02.txt

# Test
ansible-playbook pb-test.yml -i hosts | tee out/out-03.txt

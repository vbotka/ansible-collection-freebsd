#!/usr/bin/bash

. ../defaults/batch

# Status of jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-02.txt

# Test
ansible-playbook pb-test-all.yml -i hosts | tee out/out-03.txt
ansible-playbook pb-test-EU.yml -i hosts | tee out/out-04.txt

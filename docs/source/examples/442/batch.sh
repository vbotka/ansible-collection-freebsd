#!/usr/bin/bash

. ../defaults/batch

# Status of swarms
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Test
ansible-playbook pb-test.yml -i hosts  --flush-cache | tee out/out-03.txt

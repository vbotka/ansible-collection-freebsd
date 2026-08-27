#!/usr/bin/bash

. ../defaults/batch

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Inventory graph
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-09.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-06.txt
ansible-playbook -i hosts pb-test-db.yml | tee out/out-07.txt
# ansible-playbook -i hosts pb-test-connection.yml | tee out/out-08.txt

#!/usr/bin/bash

. ../defaults/batch

# Inventory graph
ansible-inventory -i iocage.yml --graph | tee out/out-01.txt
ansible-inventory -i iocage2.yml --graph | tee out/out-02.txt

# Display iocage_* vars
ansible-playbook -i iocage.yml -e test_file_prefix=iocage- pb-vars-all.yml | tee out/out-03.txt
ansible-playbook -i iocage2.yml -e test_file_prefix=iocage2- pb-vars-all.yml | tee out/out-04.txt

# Test iocage_* vars (See README)
# ansible-playbook pb-test-iocage-vars.yml

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# NOTE: This example doesn't run in the batch. (.deny)
# The template and jails are created in sandbox 020.

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-01.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-02.txt

# Inventory graph
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-03.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-04.txt
# ansible-playbook -i hosts pb-test-db.yml | tee out/out-05.txt
ansible-playbook -i hosts pb-test-connection.yml | tee out/out-06.txt

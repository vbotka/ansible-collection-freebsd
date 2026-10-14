#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

ssh admin@iocage_05 sudo iocage destroy -f test-511 test-512 test-513
ssh admin@iocage_05 sudo iocage destroy -f ansible-test
ssh admin@iocage_06 sudo iocage destroy -f test-611 test-612 test-613
ssh admin@iocage_06 sudo iocage destroy -f ansible-test

# Create jails
ansible-playbook -i iocage.ini pb-iocage-fetch-base-clone-list.yml | tee out/out-01.txt

# Status of jails
ssh admin@iocage_05 sudo iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test
ansible-playbook -i iocage.yml pb-test.yml | tee out/out-04.txt

touch .done

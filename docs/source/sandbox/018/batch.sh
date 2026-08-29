#!/usr/bin/bash

. ../defaults/batch

# Stop and destroy jails.
# ssh admin@iocage_06 sudo iocage clean -jf
# ssh admin@iocage_06 sudo iocage stop test_151
# ssh admin@iocage_06 sudo iocage stop test_152
# ssh admin@iocage_06 sudo iocage stop test_153
ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create templates
(cd ../010 && ansible-playbook -i iocage.ini -t create pb-iocage-fetch-base-clone-list.yml)

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-02.txt

# Create jails
ansible-playbook -i iocage.ini pb-iocage-clone-list.yml | tee out/out-03.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt
ansible-inventory -i hosts --list --yaml | tee out/out-06.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-07.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt
ansible-playbook -i hosts pb-test.yml | tee out/out-09.txt

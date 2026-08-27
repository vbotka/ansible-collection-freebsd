#!/usr/bin/bash

. ../defaults/batch

# Stop and destroy jails.
# ssh admin@iocage_06 sudo iocage clean -jf
ssh admin@iocage_06 sudo iocage stop test_151
ssh admin@iocage_06 sudo iocage stop test_152
ssh admin@iocage_06 sudo iocage stop test_153
ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
ssh admin@iocage_06 sudo iocage destroy -f ansible_client

# Create templates
(cd ../010 && ansible-playbook pb-iocage-fetch-base-clone-list.yml -i iocage.ini -t create)

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-02.txt

# Create jails
ansible-playbook pb-iocage-clone-list.yml -i iocage.ini | tee out/out-03.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt
ansible-inventory -i hosts --list --yaml | tee out/out-06.txt

# Test
ansible-playbook pb-test.yml -i hosts  | tee out/out-07.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt
ansible-playbook pb-test.yml -i hosts | tee out/out-09.txt

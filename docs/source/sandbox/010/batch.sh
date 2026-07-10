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

# Create jails.
ansible-playbook pb-iocage-fetch-base-clone-list.yml -i iocage.ini | tee out/out-01.txt

# Status of jails.
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test.
ansible-playbook pb-test.yml -i iocage.yml | tee out/out-04.txt

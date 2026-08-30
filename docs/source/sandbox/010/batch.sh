#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Stop and destroy jails.
# ssh admin@iocage_06 sudo iocage clean -jf
ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create jails.
ansible-playbook -i iocage.ini pb-iocage-fetch-base-clone-list.yml | tee out/out-01.txt

# Status of jails.
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test.
ansible-playbook -i iocage2.yml pb-test.yml | tee out/out-04.txt

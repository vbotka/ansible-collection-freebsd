#!/usr/bin/bash

. ../defaults/batch

# Stop and destroy jails.
# ssh admin@iocage_06 sudo iocage clean -jf
ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create basejails
ansible-playbook -i iocage.ini pb-iocage-base.yml | tee out/out-01.txt

# Create clones
ansible-playbook -i iocage.ini pb-iocage-clone.yml | tee out/out-02.txt

# Display variables and groups
ansible-playbook -i hosts --flush-cache pb-all.yml | tee out/out-03.txt

# Display iocage tags and groups
ansible-playbook -i hosts pb-ansible-client.yml | tee out/out-04.txt

# Display all jails
ansible-playbook -i hosts pb-test.yml | tee out/out-05.txt

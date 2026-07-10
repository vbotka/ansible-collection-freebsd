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

# Create basejails
ansible-playbook pb-iocage-base.yml -i iocage.ini | tee out/out-01.txt

# Create clones
ansible-playbook pb-iocage-clone.yml -i iocage.ini | tee out/out-02.txt

# Display variables and groups
ansible-playbook pb-all.yml -i hosts --flush-cache | tee out/out-03.txt

# Display iocage tags and groups
ansible-playbook pb-ansible-client.yml -i hosts | tee out/out-04.txt

# Display all jails
ansible-playbook pb-test.yml -i hosts | tee out/out-05.txt

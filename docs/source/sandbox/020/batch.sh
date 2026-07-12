#!/usr/bin/bash

. ../defaults/batch

# Stop and destroy jails.
# ssh admin@iocage_06 sudo iocage clean -jf
ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
ssh admin@iocage_06 sudo iocage destroy -f ansible_client

# Create templates
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini --flush-cache) 

# Status of templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create jails
ansible-playbook pb-iocage-swarms-create.yml -i iocage.ini --flush-cache | tee out/out-03.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Inventory graph
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-09.txt

# Test
ansible-playbook pb-test-all.yml -i hosts --flush-cache | tee out/out-06.txt
ansible-playbook pb-test-db.yml -i hosts | tee out/out-07.txt

# ansible-playbook pb-iocage-swarms-destroy.yml -i iocage.ini -i hosts | tee out/out-08.txt

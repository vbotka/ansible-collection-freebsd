#!/usr/bin/bash

. ../defaults/batch

# Stop and destroy jails.
# ssh admin@iocage_06 sudo iocage clean -jf
ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
# ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create templates
(cd ../202 && ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml) 

# Status of templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create jails
ansible-playbook -i iocage.ini --flush-cache pb-iocage-swarms-create.yml | tee out/out-03.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Inventory graph
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-09.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-06.txt
ansible-playbook -i hosts pb-test-db.yml | tee out/out-07.txt

# ansible-playbook pb-iocage-swarms-destroy.yml -i iocage.ini -i hosts | tee out/out-08.txt

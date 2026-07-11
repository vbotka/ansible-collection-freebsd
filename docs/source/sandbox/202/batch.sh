#!/usr/bin/bash

. ../defaults/batch

ssh admin@iocage_06 sudo iocage destroy -f test_151
ssh admin@iocage_06 sudo iocage destroy -f test_152
ssh admin@iocage_06 sudo iocage destroy -f test_153
ssh admin@iocage_06 sudo iocage destroy -f ansible_client

# Create templates
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -e debug=true -e debug2=false --flush-cache | tee out/out-01.txt

# Status of templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create clones
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone -e clone=true --flush-cache | tee out/out-03.txt

# Status of clones
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Test
# ansible-playbook pb-test.yml -i hosts --flush-cache | tee out/out-06.txt

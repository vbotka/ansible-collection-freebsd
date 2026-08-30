#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

ssh admin@iocage_06 sudo iocage destroy -f test-151
ssh admin@iocage_06 sudo iocage destroy -f test-152
ssh admin@iocage_06 sudo iocage destroy -f test-153
ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create templates
ansible-playbook -i iocage.ini -e debug=true -e debug2=false --flush-cache vbotka.freebsd.pb_iocage_template.yml | tee out/out-01.txt

# Status of templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create clones
ansible-playbook -i iocage.ini -t clone -e clone=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-03.txt

# Status of clones
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test.yml | tee out/out-06.txt

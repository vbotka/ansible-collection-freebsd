#!/usr/bin/bash

. ../defaults/batch

# Create templates
(cd ../202 && ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml)

# Status of templates
ssh admin@iocage_06 iocage list -lt | tee out/out-01.txt

# Create swarms
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e debug=true --flush-cache vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-02.txt

# Status of swarms
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt
ansible-inventory -i hosts --graph | tee out/out-04.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test.yml | tee out/out-05.txt

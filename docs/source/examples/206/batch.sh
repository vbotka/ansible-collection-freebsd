#!/usr/bin/bash

. ../defaults/batch

# Ddestroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Create templates
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini --flush-cache)

# Status
ssh admin@$iocage_04 iocage list -lt | tee out/out-01.txt

# Create jails
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone -e clone=true | tee out/out-02.txt
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true -e debug=true | tee out/out-03.txt

# Status of jails
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-04.txt
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Test
ansible-playbook pb-test.yml -i hosts  --flush-cache| tee out/out-06.txt

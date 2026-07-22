#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml

# Fetch plugins
ansible-playbook -i iocage.ini -t swarm_plugins -e debug=true vbotka.freebsd.pb_iocage_plugins.yml | tee out/out-01.txt

# List plugins
ssh admin@iocage_06 sudo iocage list -P | tee out/out-02.txt

# Create swarms
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e debug=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-03.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test.yml | tee out/out-06.txt

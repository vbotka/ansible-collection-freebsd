#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Fetch plugins
ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml -i iocage.ini -t required_plugins -e debug=true | tee out/out-01.txt

# List plugins
ssh admin@$iocage_05 sudo iocage list -P | tee out/out-02.txt

# Create swarms
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true -e debug=true | tee out/out-03.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-04.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Test
ansible-playbook pb-test.yml -i hosts  --flush-cache | tee out/out-06.txt

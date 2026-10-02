#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Destroy templates
# ssh admin@$iocage_02 sudo iocage destroy -f ansible-client
# ssh admin@$iocage_04 sudo iocage destroy -f ansible-client

# Create templates
ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml | tee out/out-01.txt

# Status of templates
ssh admin@$iocage_02 sudo iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_04 sudo iocage list -lt | tee out/out-03.txt

# Create clones
ansible-playbook -i iocage.ini -t clone -e clone=true --flush-cache vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-04.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-07.txt

# Jails
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-05.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-06.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test.yml | tee out/out-08.txt

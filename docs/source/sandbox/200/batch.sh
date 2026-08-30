#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml
ssh admin@iocage_06 sudo iocage destroy -f test-151
ssh admin@iocage_06 sudo iocage destroy -f test-152
ssh admin@iocage_06 sudo iocage destroy -f test-153

# Destroy template ansible-client
ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create templates
ansible-playbook -i iocage.ini \
		 -e debug=true -e debug2=false \
                  vbotka.freebsd.pb_iocage_template.yml | tee out/out-01.txt

# Status of templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-03.txt

# Create clones
ansible-playbook -i iocage.ini -t clone -e clone=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-04.txt

# Status of clones
ansible-playbook -i iocage.ini -t list -e debug=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-05.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-07.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-08.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-09.txt

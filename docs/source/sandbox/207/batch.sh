#!/usr/bin/bash

. ../defaults/batch

# Destroy all jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml

# Destroy ansible_client templates
# ssh admin@$iocage_05 sudo iocage destroy -f ansible_client

# Create templates
(cd ../202 && ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml)

# List templates
ssh admin@iocage_06 iocage list -lt | tee out/out-03.txt

# Create test jails
ssh admin@iocage_06 sudo iocage create -n test_5 -r 15.1-RELEASE

# Create project
ansible-playbook -i iocage.ini -i hosts -e debug=true --flush-cache vbotka.freebsd.pb_iocage_project_create.yml | tee out/out-04.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt
ansible-inventory -i hosts --graph  --flush-cache | tee out/out-09.txt

# Test all jails
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-05.txt

# Destroy project
# ansible-playbook -i iocage.ini -i hosts -e debug=true vbotka.freebsd.pb_iocage_project_destroy.yml | tee out/out-06.txt

# Test all jails
# ansible-playbook -i hosts --flush-cache pb-test-all.yml --flush-cache | tee out/out-07.txt

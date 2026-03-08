#!/usr/bin/bash

. ../defaults/batch

# Destroy all jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Destroy ansible_client templates
# ssh admin@$iocage_05 sudo iocage destroy -f ansible_client

# Create templates
(cd ../202 && ansible-playbook pb-iocage-template.yml -i iocage.ini --flush-cache)

# List templates
ssh admin@$iocage_05 iocage list -lt | tee out/out-03.txt

# Create test jails
ssh admin@$iocage_05 sudo iocage create -n test_5 -r 15.0-RELEASE

# Create project
ansible-playbook -i hosts -i iocage.ini vbotka.freebsd.pb_iocage_project_create.yml -e debug=true | tee out/out-04.txt

# Test all jails
ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-05.txt

# Destroy project
ansible-playbook -i hosts -i iocage.ini vbotka.freebsd.pb_iocage_project_destroy.yml -e debug=true | tee out/out-06.txt

# Test all jails
ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-07.txt

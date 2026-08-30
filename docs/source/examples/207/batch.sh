#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy all jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml

# Destroy ansible_client templates
echo admin | ssh admin@$iocage_01 sudo -S iocage destroy -f ansible_client
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# Create templates
(cd ../202 && ansible-playbook -i iocage.ini --flush-cache pb-iocage-template.yml)

# List templates
ssh admin@$iocage_01 iocage list -lt | tee out/out-01.txt
ssh admin@$iocage_02 iocage list -lt | tee out/out-02.txt
ssh admin@$iocage_04 iocage list -lt | tee out/out-03.txt

# Create test jails
echo admin | ssh admin@$iocage_01 sudo -S iocage create -n test_1 -r 13.5-RELEASE
ssh admin@$iocage_02 sudo iocage create -n test_2 -r 14.2-RELEASE
ssh admin@$iocage_04 sudo iocage create -n test_4 -r 14.3-RELEASE

# Create project
ansible-playbook -i hosts -i iocage.ini -e debug=true vbotka.freebsd.pb_iocage_project_create.yml | tee out/out-04.txt

# Test all jails
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-05.txt

# Destroy project
ansible-playbook -i hosts -i iocage.ini -e debug=true vbotka.freebsd.pb_iocage_project_destroy.yml | tee out/out-06.txt

# Test all jails
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-07.txt

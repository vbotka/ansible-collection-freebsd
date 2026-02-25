#!/usr/bin/bash

. ../defaults/batch

# Destroy all jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# Create templates
(cd ../208 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini)

# List templates
ssh admin@$iocage_04 iocage list -lt | tee out/out-01.txt

# Create project
ansible-playbook vbotka.freebsd.pb_iocage_project_create.yml -i hosts -i iocage.ini -e debug=true | tee out/out-02.txt
# Test all jails
ansible-playbook pb-test-all.yml -i hosts | tee out/out-03.txt

# Destroy project
ansible-playbook vbotka.freebsd.pb_iocage_project_destroy.yml -i hosts -i iocage.ini -e debug=true | tee out/out-04.txt
# Test all jails
ansible-playbook pb-test-all.yml -i hosts | tee out/out-05.txt

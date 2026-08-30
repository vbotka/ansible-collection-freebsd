#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
#VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
# ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create templates
# (cd ../202 && ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml) 

# Status of templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-01.txt

# Create jails
ansible-playbook -i iocage.ini --flush-cache pb-iocage-swarms-create.yml | tee out/out-03.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Test
ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-06.txt
# ansible-playbook -i hosts pb-test-db.yml | tee out/out-07.txt

# ansible-playbook -i iocage.ini -i hosts pb-iocage-swarms-destroy.yml | tee out/out-08.txt

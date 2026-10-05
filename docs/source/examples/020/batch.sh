#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
#VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
# ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create templates
# (cd ../202 && ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml) 

# Templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-01.txt

# Create jails
ansible-playbook -i iocage.ini -e debug=true --flush-cache pb-iocage-swarms-create.yml | tee out/out-03.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-04.txt 

# Jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Test project
ansible-playbook -i hosts --flush-cache pb-test-project.yml | tee out/out-06.txt
# ansible-playbook -i hosts pb-test-properties.yml
# ansible-playbook -i hosts pb-test-hostuuid.yml
# ansible-playbook -i hosts pb-test-connection.yml

# Destroy swarms. (The jails are used in 021).
# ansible-playbook -i iocage.ini -i hosts --flush-cache pb-iocage-swarms-destroy.yml | tee out/out-07.txt

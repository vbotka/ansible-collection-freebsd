#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Fetch plugins
ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml -i iocage.ini -t project_plugins -e debug=true | tee out/out-01.txt

# List plugins
ssh admin@$iocage_05 sudo iocage list -P | tee out/out-02.txt

# Create the project
ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_plugins.yml -i iocage.ini -i hosts --flush-cache | tee out/out-03.txt

# Status of the project
ansible-playbook pb-all-groups.yml -i hosts --flush-cache | tee out/out-04.txt

# Create Log Server
ansible-playbook pb-logserv.yml -i hosts | tee out/out-05.txt

# Test Log Server
ansible-playbook pb-test-logserv.yml -i hosts -e debug=true | tee out/out-09.txt

# Create Log Clients
ansible-playbook pb-logclient.yml -i hosts -i iocage.ini -e debug=true | tee out/out-06.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-08.txt

# Test Log Clients
ansible-playbook pb-test-logclient.yml -i hosts | tee out/out-07.txt

# ansible-playbook pb-iocage-project-destroy.yml -i hosts -i iocage.ini -e debug=true | tee out/out-06.txt
# ansible-playbook pb-test-all.yml -i hosts --flush-cache | tee out/out-07.txt

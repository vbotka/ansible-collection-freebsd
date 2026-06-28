#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# Fetch plugins
ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml -i iocage.ini -t enabled_plugins -e debug=true | tee out/out-01.txt

# List plugins
ssh admin@$iocage_05 sudo iocage list -P | tee out/out-02.txt

# Create jails
ansible-playbook pb-create-jails.yml -i iocage.ini | tee out/out-03.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-04.txt

# Inventory
ansible-inventory -i hosts --list --yaml | tee out/out-05.txt

# Display all groups
ansible-playbook pb-all-groups.yml -i hosts | tee out/out-06.txt

# Start jails
ansible-playbook pb-start-jails.yml -i hosts -i iocage.ini -e debug=true | tee out/out-07.txt

# Configure Log Server
ansible-playbook pb-logserv.yml -i hosts | tee out/out-08.txt

# Test Log Server
ansible-playbook pb-test-logserv.yml -i hosts -e debug=true | tee out/out-09.txt

# Configure Log Clients
ansible-playbook pb-logclient.yml -i hosts -i iocage.ini -e debug=true | tee out/out-10.txt

# Test Log Clients
ansible-playbook pb-test-logclient.yml -i hosts | tee out/out-11.txt

#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# Create templates
ansible-playbook pb-iocage-template.yml -i iocage.ini | tee out/out-01.txt

# Configure templates.
ansible-playbook pb-logserver.yml -i hosts | tee out/out-02.txt
ansible-playbook pb-logclient.yml -i hosts | tee out/out-03.txt

# Stop and convert templates.
ansible-playbook pb-template-stop-convert.yml -i iocage.ini | tee out/out-04.txt

# List templates
ssh admin@$iocage_05 sudo iocage list -lt | tee out/out-05.txt

# Create jails
ansible-playbook pb-create-jails.yml -i iocage.ini | tee out/out-06.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-07.txt

# Configure Log Clients LOG_SERVER, enable, and start syslog-ng 
ansible-playbook pb-logclient-conf.yml -i hosts -i iocage.ini -e debug=true | tee out/out-08.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-09.txt

# Test Log Server
ansible-playbook pb-logserver-test.yml -i hosts -e debug=true | tee out/out-10.txt

# Test Log Clients
ansible-playbook pb-logclient-test.yml -i hosts | tee out/out-11.txt

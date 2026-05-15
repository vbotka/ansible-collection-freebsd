#!/usr/bin/bash

. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# Create template
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini | tee out/out-01.txt

# Configure template.
# THIS PLAY WONT RUN IF TEMPLATE ansible_syslogng_server EXISTS.
# THE batch.sh WILL PROCEED.
ansible-playbook pb-logclient.yml -i hosts | tee out/out-02.txt

# Stop and convert template.
# THIS PLAY WILL CRASH IF TEMPLATE ansible_syslogng_server EXISTS.
# THE batch.sh WILL PROCEED.
ansible-playbook pb-logclient-stop-convert.yml -i iocage.ini | tee out/out-03.txt

# List templates
ssh admin@$iocage_05 sudo iocage list -lt | tee out/out-04.txt

# Create jails
ansible-playbook pb-create-jails.yml -i iocage.ini | tee out/out-05.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-06.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-07.txt

# Configure Log Clients LOG_SERVER, enable, and start syslog-ng
ansible-playbook pb-logclient-conf.yml -i hosts -e debug=true | tee out/out-08.txt

# Test Log Server
ansible-playbook pb-logclient-test.yml -i hosts -e debug=true | tee out/out-08.txt

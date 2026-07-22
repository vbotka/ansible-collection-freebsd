#!/usr/bin/bash

. ../defaults/batch

# Create template
ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml | tee out/out-01.txt

# Configure template.
# THIS PLAY WONT RUN IF TEMPLATE ansible-syslogng-server EXISTS.
# THE batch.sh WILL PROCEED.
ansible-playbook -i hosts pb-logserver.yml | tee out/out-02.txt

# Stop and convert template.
ansible-playbook -i iocage.ini pb-logserver-stop-convert.yml | tee out/out-03.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-04.txt

# Create jails
ansible-playbook -i iocage.ini pb-create-jails.yml | tee out/out-05.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-06.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-07.txt

# Test Log Server
ansible-playbook -i hosts -e debug=true pb-logserver-test.yml | tee out/out-08.txt

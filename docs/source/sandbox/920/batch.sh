#!/usr/bin/bash

. ../defaults/batch

# Stop log_server, www-01, and www-02
ssh admin@$iocage_05 sudo iocage stop log-server
ssh admin@$iocage_05 sudo iocage stop www-01
ssh admin@$iocage_05 sudo iocage stop www-02
# Destroy log_server, www-01, and www-02
ssh admin@$iocage_05 sudo iocage destroy -f log-server
ssh admin@$iocage_05 sudo iocage destroy -f www-01
ssh admin@$iocage_05 sudo iocage destroy -f www-02

# List templates
ssh admin@$iocage_05 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts | tee out/out-03.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-04.txt

# Test (if at=now add 90 to sleep)
sleep 120
ansible-playbook pb-logserver-test.yml -i hosts -e debug=true | tee out/out-05.txt
ansible-playbook pb-logclient-test.yml -i hosts | tee out/out-06.txt

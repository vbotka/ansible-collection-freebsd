#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy log-server-01, www-01, and www-02
ssh admin@iocage_06 sudo iocage destroy -f log-server
ssh admin@iocage_06 sudo iocage destroy -f log-server-01
ssh admin@iocage_06 sudo iocage destroy -f www-01
ssh admin@iocage_06 sudo iocage destroy -f www-02

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-03.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-04.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Test. Adjust the sleep time to your system. Most of the time is consumed by installing the
# packages. If you schedule ansible_pull at=now add 90 to sleep for cron.
sleep 40
ansible-playbook -i hosts -e debug=true pb-logserver-test.yml | tee out/out-06.txt
ansible-playbook -i hosts pb-logclient-test.yml | tee out/out-07.txt

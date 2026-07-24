#!/usr/bin/bash

. ../defaults/batch

# Stop log-server, www-01, and www-02
# ssh admin@iocage_06 sudo iocage stop log-server
# ssh admin@iocage_06 sudo iocage stop www-01
# ssh admin@iocage_06 sudo iocage stop www-02

# Destroy log-server, www-01, and www-02
ssh admin@iocage_06 sudo iocage destroy -f log-server
ssh admin@iocage_06 sudo iocage destroy -f www-01
ssh admin@iocage_06 sudo iocage destroy -f www-02

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts | tee out/out-03.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-04.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Test. Adjust the sleep time to your system. Most of the time is consumed by installing the
# packages. If you schedule ansible_pull at=now add 90 to sleep for cron.
sleep 120
ansible-playbook pb-logserver-test.yml -i hosts -e debug=true | tee out/out-06.txt
ansible-playbook pb-logclient-test.yml -i hosts | tee out/out-07.txt

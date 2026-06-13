#!/usr/bin/bash

. ../defaults/batch

# Stop log_server, foo, and bar
ssh admin@$iocage_05 sudo iocage stop log-server
ssh admin@$iocage_05 sudo iocage stop www-01
ssh admin@$iocage_05 sudo iocage stop www-02
# Destroy log_server, foo, and bar
ssh admin@$iocage_05 sudo iocage destroy -f log-server
ssh admin@$iocage_05 sudo iocage destroy -f www-01
ssh admin@$iocage_05 sudo iocage destroy -f www-02

# List templates
ssh admin@$iocage_05 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts | tee out/out-03.txt

# List jails
ssh admin@$iocage_05 sudo iocage list -l | tee out/out-04.txt

# Test (if at=now set sleep 90)
# sleep 3
# ssh admin@$iocage_05 sudo iocage exec baz "cat /tmp/ansible-hello-world.txt" | tee out/out-05.txt
# ssh admin@$iocage_05 sudo iocage exec qux "cat /tmp/ansible-hello-world.txt" | tee out/out-06.txt

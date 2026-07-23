#!/usr/bin/bash

. ../defaults/batch

# Stop jails foo and bar
# ssh admin@iocage_06 sudo iocage stop foo
# ssh admin@iocage_06 sudo iocage stop bar

# Destroy jails foo and bar
ssh admin@iocage_06 sudo iocage destroy -f foo
ssh admin@iocage_06 sudo iocage destroy -f bar

# Destroy template ansible-init-devel
ssh admin@iocage_06 sudo iocage destroy -f ansible-init-devel

# Create template
ansible-playbook pb-iocage-template.yml -i iocage.ini | tee out/out-01.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

# Create the project
ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts | tee out/out-03.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-04.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-05.txt

# Test (if at=now set sleep 90)
sleep 5
ssh admin@iocage_06 sudo iocage exec foo "cat /tmp/ansible-hello-world.txt" | tee out/out-06.txt
ssh admin@iocage_06 sudo iocage exec bar "cat /tmp/ansible-hello-world.txt" | tee out/out-07.txt

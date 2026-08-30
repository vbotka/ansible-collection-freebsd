#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Stop foo, bar, and log-server
ssh admin@iocage_06 sudo iocage stop foo
ssh admin@iocage_06 sudo iocage stop bar
ssh admin@iocage_06 sudo iocage stop log-server
ssh admin@iocage_06 sudo iocage stop log-server-01

# Destroy foo, bar, and log-server
ssh admin@iocage_06 sudo iocage destroy -f foo
ssh admin@iocage_06 sudo iocage destroy -f bar
ssh admin@iocage_06 sudo iocage destroy -f log-server
ssh admin@iocage_06 sudo iocage destroy -f log-server-01

# Create templates
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# Configure templates.
ansible-playbook -i hosts pb-logserver.yml | tee out/out-02.txt
ansible-playbook -i hosts pb-logclient.yml | tee out/out-03.txt

# Stop and convert templates.
ansible-playbook -i iocage.ini pb-iocage-template-stop-convert.yml | tee out/out-04.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-05.txt

# Create jails
ansible-playbook -i iocage.ini -i hosts pb-create-jails.yml | tee out/out-06.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-07.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt

# Test Log Server
ansible-playbook -i hosts -e debug=true pb-logserver-test.yml | tee out/out-09.txt

# Test Log Clients
ansible-playbook -i hosts pb-logclient-test.yml | tee out/out-10.txt

#!/usr/bin/bash

. ../defaults/batch

# Stop foo and bar
ssh admin@$iocage_05 sudo iocage stop foo bar

# Destroy foo and bar
ssh admin@$iocage_05 sudo iocage destroy -f foo bar

# Fetch plugins
ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml -i iocage.ini -t enabled_plugins -e debug=true | tee out/out-01.txt

# List plugins
ssh admin@$iocage_05 sudo iocage list -P | tee out/out-02.txt

# Create jails
ansible-playbook pb-create-jails.yml -i iocage.ini -i hosts | tee out/out-03.txt

# List jails
# ssh admin@$iocage_05 sudo iocage list -l | tee out/out-04.txt

# Inventory
# ansible-inventory -i hosts --list --yaml | tee out/out-05.txt

# Display all groups
# ansible-playbook pb-all-groups.yml -i hosts | tee out/out-06.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-07.txt

# Test Log Clients
ansible-playbook pb-test-logclient.yml -i hosts -e debug=true | tee out/out-08.txt

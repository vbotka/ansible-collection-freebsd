#!/usr/bin/bash

. ../defaults/batch

# Stop foo and bar
# ssh admin@$iocage_05 sudo iocage stop foo bar log-server

# Destroy foo and bar
# ssh admin@$iocage_05 sudo iocage destroy -f foo bar log-server

# Fetch plugins
ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml -i iocage.ini -t enabled_plugins -e debug=true | tee out/out-01.txt

# List plugins
ssh admin@$iocage_05 sudo iocage list -P | tee out/out-02.txt

# Create jails
ansible-playbook pb-create-jails.yml -i iocage.ini -i hosts | tee out/out-03.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-04.txt

# Test Log Server
ansible-playbook pb-logserver-test.yml -i hosts -e debug=true | tee out/out-05.txt

# Test Log Clients
ansible-playbook pb-logclient-test.yml -i hosts | tee out/out-06.txt

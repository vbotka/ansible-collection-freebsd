#!/usr/bin/bash

. ../defaults/batch

# Stop test
ssh admin@iocage_06 sudo iocage stop test

# Destroy test
ssh admin@iocage_06 sudo iocage destroy -f test

# Fetch plugins
ansible-playbook -i iocage.ini -t enabled_plugins -e debug=true vbotka.freebsd.pb_iocage_plugins.yml | tee out/out-01.txt

# List plugins
ssh admin@iocage_06 sudo iocage list -P | tee out/out-02.txt

# Create jails
ansible-playbook -i iocage.ini pb-create-jails.yml | tee out/out-03.txt

# List jails
# ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Display all groups
# ansible-playbook -i hosts pb-all-groups.yml | tee out/out-05.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-06.txt

# Start jails
# ansible-playbook -i hosts -i iocage.ini -e debug=true pb-start-jails.yml | tee out/out-07.txt

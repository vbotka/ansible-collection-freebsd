#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml
echo admin | ssh admin@$iocage_01 sudo -S iocage destroy -f ansible_client
ssh admin@$iocage_02 sudo iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# Prepare
echo "*** Create templates."
(cd ../202 && ansible-playbook -i iocage.ini --flush-cache pb-iocage-template.yml)
echo "*** Show inventory."
(cd ../207 && ansible-inventory -i iocage.ini -i hosts --graph)
echo "*** Create jails."
(cd ../207 && ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create.yml)

# Status of the project
ansible-playbook -i hosts --flush-cache pb-all-groups.yml | tee out/out-01.txt

# Create Log Server
ansible-playbook -i hosts -e install=true pb-logserv.yml | tee out/out-02.txt

# Create Log Clients
ansible-playbook -i hosts -i iocage.ini -e install=true -e debug=true pb-logclient.yml | tee out/out-03.txt

# Test
ansible-playbook -i hosts pb-test-logclient.yml | tee out/out-04.txt

# ansible-playbook -i hosts -i iocage.ini -e debug=true pb-iocage-project-destroy.yml | tee out/out-06.txt
# ansible-playbook -i hosts --flush-cache pb-test-all.yml | tee out/out-07.txt

#!/usr/bin/bash
. ../defaults/batch

# Destroy jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# Create template
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -l iocage_04)

# Create jails
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true | tee out/out-01.txt

# Status of jails
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-02.txt
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-03.txt

# Install packages
ansible-playbook pb-install.yml -i hosts -i iocage.ini --flush-cache | tee out/out-04.txt

# Test
ansible-playbook pb-test.yml -i hosts -t rsnapshot_debug -e rsnapshot_debug=true | tee out/out-05.txt
ansible-playbook pb-test.yml -i hosts | tee out/out-06.txt

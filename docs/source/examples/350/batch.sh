#!/usr/bin/bash
# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
# ssh admin@iocage_06 sudo iocage destroy -f ansible-client

# Create template
# (cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -l iocage_04)

# Create jails
ansible-playbook -i iocage.ini -t swarm -e swarm=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-02.txt
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-03.txt

# Install packages
ansible-playbook -i hosts -i iocage.ini  pb-install.yml | tee out/out-04.txt

# Test
ansible-playbook -i hosts -t rsnapshot_debug -e rsnapshot_debug=true pb-test.yml | tee out/out-05.txt
ansible-playbook -i hosts pb-test.yml | tee out/out-06.txt

# Destroy swarms
ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-07.txt

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
ssh admin@iocage_06 sudo iocage destroy -f test-161
ssh admin@iocage_06 sudo iocage destroy -f test-162
ssh admin@iocage_06 sudo iocage destroy -f test-163

# Create templates
# (cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini --flush-cache)

# Templates
ssh admin@iocage_06 iocage list -lt | tee out/out-01.txt

# Create jails
ansible-playbook -i iocage.ini -t clone -e clone=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-02.txt
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e debug=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-03.txt

# Jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-06.txt

# Destroy swarms
ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-07.txt

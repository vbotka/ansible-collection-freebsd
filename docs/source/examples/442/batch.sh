#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-01.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-03.txt

# Destroy swarm (441 creates sw_01)
ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Status of swarms
ssh admin@iocage_06 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Test
ansible-playbook pb-test.yml -i hosts | tee out/out-03.txt

# Destroy swarm (441 creates sw_01)
# ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml

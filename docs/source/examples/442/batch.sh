#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph.
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-04.txt

# Destroy the swarms in batch. (441 creates sw_01.)
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i hosts -i iocage.ini -t swarm_destroy -e swarm_destroy=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml
fi

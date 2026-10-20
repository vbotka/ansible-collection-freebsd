#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# In batch, destroy swarms.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml
fi

# Templates.
ssh admin@iocage_05 iocage list -lt | tee out/out-01.txt
ssh admin@iocage_06 iocage list -lt | tee out/out-02.txt

# Create swarms.
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e debug=false vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-03.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-04.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-05.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-06.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-07.txt

# In batch, destroy swarms.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml
fi

touch .done

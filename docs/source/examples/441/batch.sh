#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy swarms.
ansible-playbook -i hosts -i iocage.ini -t swarm_destroy -e swarm_destroy=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml

# Templates.
# ssh admin@iocage_05 iocage list -lt | tee out/out-01.txt
# ssh admin@iocage_06 iocage list -lt | tee out/out-02.txt

# Swarms.
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-03.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-04.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-05.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-06.txt

# Test.
ansible-playbook -i hosts pb-test.yml | tee out/out-07.txt

# Do not destroy swarms (442 needs sw_01).

touch .done

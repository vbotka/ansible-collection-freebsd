#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-01.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Test
ansible-playbook -i hosts pb-test-project.yml | tee out/out-03.txt
ansible-playbook -i hosts pb-test-connection-vars.yml | tee out/out-04.txt
ansible-playbook -i hosts pb-test-connection.yml | tee out/out-05.txt

# Destroy swarms. (The jails are created in 020).
ansible-playbook -i iocage.ini -i hosts pb-iocage-swarms-destroy.yml | tee out/out-06.txt

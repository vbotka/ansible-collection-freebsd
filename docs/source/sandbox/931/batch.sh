#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Test filter vbotka.freebsd.combine_properties
ansible-playbook -i iocage.ini pb-207.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini pb-435.yml | tee out/out-02.txt
ansible-playbook -i iocage.ini pb-test.yml | tee out/out-05.txt
ansible-playbook -i iocage.ini pb-test-swarm.yml | tee out/out-06.txt
ansible-playbook -i hosts pb-inventory.yml | tee out/out-04.txt

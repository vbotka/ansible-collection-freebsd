#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Status of the jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-02.txt

# Debug versions
ansible-playbook -i iocage.ini -t freebsd_iocage_debug -e freebsd_iocage_debug=true pb-iocage.yml | grep version | tee out/out-03.txt

# Create custom fact scripts
ansible-playbook -i iocage.ini -t freebsd_iocage_facts -e freebsd_iocage_facts=true pb-iocage.yml | tee out/out-04.txt

# Display custom fact script
ssh admin@iocage_06 cat /etc/ansible/facts.d/iocage.fact | tee out/out-05.txt

# Test
ansible-playbook -i iocage.ini pb-test.yml | tee out/out-06.txt

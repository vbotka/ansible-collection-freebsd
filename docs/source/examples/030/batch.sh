#!/usr/bin/bash

. ../defaults/batch

# status
ssh admin@$iocage_02 sudo iocage list -l | tee out/out-01.txt
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-02.txt

# debug
ansible-playbook pb-iocage.yml -i iocage.ini -t freebsd_iocage_debug -e freebsd_iocage_debug=true | grep version | tee out/out-03.txt

# create custom fact scripts
ansible-playbook pb-iocage.yml -i iocage.ini -t freebsd_iocage_facts -e freebsd_iocage_facts=true | tee out/out-04.txt

# display custom fact script
ssh admin@$iocage_02 cat /etc/ansible/facts.d/iocage.fact | tee out/out-05.txt

# test
ansible-playbook pb-test.yml -i iocage.ini | tee out/out-06.txt

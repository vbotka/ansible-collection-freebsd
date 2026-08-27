#!/usr/bin/bash

. ../defaults/batch

ansible-playbook -i iocage.ini pb-test-01.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini pb-test-02.yml --check --diff | tee out/out-02.txt

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Graph
ansible-inventory -i hosts --graph | tee out/out-01.txt

# Jails
ssh admin@iocage_05 iocage list -l | tee out/out-02.txt
ssh admin@iocage_06 iocage list -l | tee out/out-03.txt

# Test
ansible-playbook -i hosts pb-test.yml | tee out/out-04.txt

touch .done

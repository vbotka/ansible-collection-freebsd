#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

ssh admin@iocage_05 sudo iocage destroy -f ansible-client
ssh admin@iocage_06 sudo iocage destroy -f ansible-client
ssh admin@iocage_05 sudo iocage destroy -f ansible-test
ssh admin@iocage_06 sudo iocage destroy -f ansible-test

# Create basejails
ansible-playbook -i iocage.ini pb-iocage-base.yml | tee out/out-01.txt

# Create clones
ansible-playbook -i iocage.ini pb-iocage-clone.yml| tee out/out-02.txt

# Display variables and groups
ansible-playbook -i hosts pb-all.yml | tee out/out-03.txt

# Display iocage tags and groups
ansible-playbook -i hosts pb-ansible-test.yml | tee out/out-04.txt

# Display all jails
ansible-playbook -i hosts pb-test.yml | tee out/out-05.txt

touch .done

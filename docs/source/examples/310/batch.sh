#!/usr/bin/bash

. ../defaults/batch

ssh admin@$iocage_04 sudo iocage start ALL
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-03.txt

ansible-playbook pb-test-01.yml -i hosts | tee out/out-04.txt
ansible-playbook pb-test-02.yml -i hosts -i iocage.ini | tee out/out-05.txt
ansible-playbook pb-test-03.yml -i hosts -i iocage.ini | tee out/out-06.txt

ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks -e @extra-vars.yml | tee out/out-07.txt
ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks -e @extra-vars.yml | tee out/out-08.txt

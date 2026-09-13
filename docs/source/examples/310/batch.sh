#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Create swarm
ansible-playbook -i iocage.ini -t swarm -e swarm=true vbotka.freebsd.pb_iocage_ansible_clients.yml

# Status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-03.txt

# Test the role
ansible-playbook -i hosts pb-test-01.yml | tee out/out-04.txt
ansible-playbook -i hosts -i iocage.ini pb-test-02.yml | tee out/out-05.txt
ansible-playbook -i hosts -i iocage.ini pb-test-03.yml | tee out/out-06.txt

ansible-playbook -i hosts -i iocage.ini -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks -e @extra-vars.yml pb-test-01.yml | tee out/out-07.txt
ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook -i hosts -i iocage.ini -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks -e @extra-vars.yml pb-test-01.yml | tee out/out-08.txt

# Destroy swarms
ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true vbotka.freebsd.pb_iocage_ansible_clients.yml

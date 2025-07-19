#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb-network.yml -i iocage.ini | tee out/out-01.txt
ansible-playbook pb-pf.yml -i iocage.ini | tee out/out-02.txt
ansible-playbook pb-zfs.yml -i iocage.ini | tee out/out-03.txt
# ANSIBLE_DISPLAY_OK_HOSTS=false 

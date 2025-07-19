#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb-loader.yml -i iocage-hosts.ini -l iocage_02 | tee out/out-05.txt
ansible-playbook pb-zfs.yml -i iocage-hosts.ini -l iocage_02 -t fzfs_debug -e fzfs_debug=true | tee out/out-01.txt
ansible-playbook pb-zfs.yml -i iocage-hosts.ini -l iocage_02 | tee out/out-02.txt
ansible-playbook pb-zfs.yml -i iocage-hosts.ini -l iocage_02 -t fzfs_facts_pools -e fzfs_debug=true | tee out/out-03.txt
ansible-playbook pb-zfs.yml -i iocage-hosts.ini -l iocage_02 -t fzfs_facts_ds -e fzfs_facts_ds=true -e fzfs_debug=true | tee out/out-04.txt
# ANSIBLE_DISPLAY_OK_HOSTS=false 

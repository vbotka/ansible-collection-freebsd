#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

ansible-playbook -i iocage.ini pb-loader.yml | tee out/out-01.txt

ansible-playbook -i iocage.ini -t fzfs_debug -e fzfs_debug=true pb-zfs.yml | tee out/out-02.txt
ansible-playbook -i iocage.ini pb-zfs.yml | tee out/out-03.txt
ansible-playbook -i iocage.ini -t fzfs_facts_pools -e fzfs_debug=true pb-zfs.yml | tee out/out-04.txt
ansible-playbook -i iocage.ini -t fzfs_facts_ds -e fzfs_facts_ds=true -e fzfs_debug=true pb-zfs.yml | tee out/out-05.txt

# ANSIBLE_DISPLAY_OK_HOSTS=false 

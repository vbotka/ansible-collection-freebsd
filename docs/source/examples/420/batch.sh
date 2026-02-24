#!/usr/bin/bash
. ../defaults/batch

# destroy
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# create jails
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone_host_hostname -e clone_host_hostname=true -e debug=true -e debug2=true | tee out/out-01.txt

# create Apache HTTP Server
ansible-playbook pb-apache.yml -i hosts --flush-cache | tee out/out-02.txt

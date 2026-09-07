#!/usr/bin/bash
# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache


# Destroy www-1
ssh admin@iocage_06 sudo iocage destroy -f www-1

# Create jails
ansible-playbook -i iocage.ini -t create_host -e create_host=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Create Apache HTTP server
ansible-playbook -i hosts pb-apache.yml | tee out/out-02.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-03.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

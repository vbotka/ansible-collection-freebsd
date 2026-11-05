#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# In batch, destroy jails and templates. Copy public key.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t clone_destroy -e clone_destroy=true -e iocage_module=false vbotka.freebsd.pb_iocage_ansible_clients.yml
    ssh admin@iocage_05 sudo iocage destroy -f ansible-client
    ssh admin@iocage_06 sudo iocage destroy -f ansible-client
    cp files/pk_admins.txt.orig files/pk_admins.txt
fi

# Create templates.
ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml | tee out/out-01.txt

# Templates.
ssh admin@iocage_05 iocage list -lt | tee out/out-02.txt
ssh admin@iocage_06 iocage list -lt | tee out/out-03.txt

# Create clones.
ansible-playbook -i iocage.ini -t clone -e clone=true  vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-04.txt

# List jails.
ansible-playbook -i iocage.ini -t list -e debug=true  vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-05.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-06.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-07.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-08.txt

# Test.
ansible-playbook -i hosts  pb-test.yml | tee out/out-09.txt

# In batch, destroy jails. Sanitize public key.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t clone_destroy -e clone_destroy=true -e iocage_module=false vbotka.freebsd.pb_iocage_ansible_clients.yml
    cp files/pk_admins.txt.san files/pk_admins.txt
fi

touch .done

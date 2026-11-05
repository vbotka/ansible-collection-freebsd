#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# In batch, destroy templates and copy public key.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_05 sudo iocage destroy -f ansible-apache
    ssh admin@iocage_06 sudo iocage destroy -f ansible-apache
    cp files/pk_admins.txt.orig files/pk_admins.txt
fi

# Create pkglist file
ansible-playbook -i iocage.ini pb-pkglist.yml | tee out/out-01.txt

# Create template ansible-apache
ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml | tee out/out-02.txt

# Templates
ssh admin@iocage_05 iocage list -lt | tee out/out-03.txt
ssh admin@iocage_06 iocage list -lt | tee out/out-04.txt

# Sanitize public key in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    cp files/pk_admins.txt.san files/pk_admins.txt
fi

touch .done

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini -e target_template=ansible-init vbotka.freebsd.pb_iocage_destroy_template_jails.yml
# VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini -e target_template=ansible-nginx vbotka.freebsd.pb_iocage_destroy_template_jails.yml
# VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini -e target_template=ansible-pkg-repo vbotka.freebsd.pb_iocage_destroy_template_jails.yml
# VBOTKA_FREEBSD_BATCH=true ansible-playbook -i iocage.ini -e target_template=ansible-repos vbotka.freebsd.pb_iocage_destroy_template_jails.yml

# Destroy templates
# ssh admin@iocage_06 sudo iocage destroy -f ansible-init ansible-nginx ansible-pkg-repo ansible-repos

# Create templates
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# List templates
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-02.txt

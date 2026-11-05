#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# In batch, destroy jails and templates.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    # Destroy jails.
    ansible-playbook -i iocage.ini -e target_template=ansible-init vbotka.freebsd.pb_iocage_destroy_template_jails.yml
    ansible-playbook -i iocage.ini -e target_template=ansible-nginx vbotka.freebsd.pb_iocage_destroy_template_jails.yml
    ansible-playbook -i iocage.ini -e target_template=ansible-pkg-repo vbotka.freebsd.pb_iocage_destroy_template_jails.yml
    ansible-playbook -i iocage.ini -e target_template=ansible-repos vbotka.freebsd.pb_iocage_destroy_template_jails.yml
    # Destroy templates.
    ssh admin@iocage_05 sudo iocage destroy -f ansible-init ansible-nginx ansible-pkg-repo ansible-repos
    ssh admin@iocage_06 sudo iocage destroy -f ansible-init ansible-nginx ansible-pkg-repo ansible-repos
fi

# Create templates.
ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt

# Templates.
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-03.txt

touch .done

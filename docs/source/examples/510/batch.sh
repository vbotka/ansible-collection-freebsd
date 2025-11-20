#!/usr/bin/bash

. ../defaults/batch

# destroy all jails
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini

# create templates
(cd ../208 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini)

# list templates
ssh admin@$iocage_04 iocage list -lt | tee out/out-01.txt

# create project
ansible-playbook vbotka.freebsd.pb_iocage_project_create.yml -i hosts -i iocage.ini -e debug=true | tee out/out-02.txt
# test all jails
ansible-playbook pb-test-all.yml -i hosts | tee out/out-03.txt

# destroy project
ansible-playbook vbotka.freebsd.pb_iocage_project_destroy.yml -i hosts -i iocage.ini -e debug=true | tee out/out-04.txt
# test all jails
ansible-playbook pb-test-all.yml -i hosts | tee out/out-05.txt

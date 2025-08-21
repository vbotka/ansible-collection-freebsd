#!/usr/bin/bash

. ../defaults/batch

# create pkglist file
ansible-playbook pb-pkglist.yml -i iocage.ini | tee out/out-01.txt

# create template ansible_client_apache
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini | tee out/out-02.txt

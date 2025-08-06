#!/usr/bin/bash

. ../defaults/batch

ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -l iocage_04 -e debug=true | tee out/out-01.txt
ansible-playbook pb-test.yml -i iocage.ini -l iocage_04 | tee out/out-02.txt

#!/usr/bin/bash
. ../defaults/batch
ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -l iocage_04 | tee out/out-01.txt
ssh admin@$iocage_04 sudo iocage list -lt | tee out/out-02.txt

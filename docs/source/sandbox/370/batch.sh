#!/usr/bin/bash

. ../defaults/batch

ansible-playbook -i iocage.ini -t pf_packages -e pf_install=true pb.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini -e pf_enable=false pb.yml | tee out/out-02.txt
ansible-playbook -i iocage.ini -t pf_rcconf_pf pb.yml | tee out/out-03.txt

ssh admin@iocage_06 sudo service pf status | tee out/out-04.txt
ssh admin@iocage_06 cat /etc/pf.conf | tee out/out-05.txt

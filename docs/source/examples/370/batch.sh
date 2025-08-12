#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb.yml -i iocage.ini -t pf_packages -e pf_install=true | tee out/out-01.txt
ansible-playbook pb.yml -i iocage.ini -e pf_enable=false | tee out/out-02.txt
ansible-playbook pb.yml -i iocage.ini -t pf_rcconf_pf | tee out/out-03.txt

ssh admin@$iocage_04 sudo service pf status | tee out/out-04.txt
ssh admin@$iocage_04 cat /etc/pf.conf | tee out/out-05.txt

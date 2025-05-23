#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_03 -t pf_packages -e pf_install=true | tee out/out-01.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_03 -e pf_enable=false | tee out/out-02.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_03 -t pf_rcconf_pf | tee out/out-03.txt
ssh admin@$iocage_03 sudo service pf status | tee out/out-04.txt
ssh admin@$iocage_03 cat /etc/pf.conf | tee out/out-05.txt

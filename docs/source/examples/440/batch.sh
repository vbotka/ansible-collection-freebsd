#!/usr/bin/bash

. ../defaults/batch

ansible-playbook pb-dhcp.yml -i iocage.ini -t bsd_dhcpd_packages -e bsd_dhcpd_install=true | tee out/out-11.txt
ansible-playbook pb-dhcp.yml -i iocage.ini | tee out/out-12.txt

ansible-playbook pb-pf.yml -i iocage.ini -t pf_packages -e pf_install=true | tee out/out-01.txt
ansible-playbook pb-pf.yml -i iocage.ini -e pf_enable=false | tee out/out-02.txt
ansible-playbook pb-pf.yml -i iocage.ini -t pf_rcconf_pf | tee out/out-03.txt

ssh admin@$iocage_05 sudo service isc-dhcpd status | tee out/out-14.txt
ssh admin@$iocage_05 cat /usr/local/etc/dhcpd.conf  | tee out/out-15.txt

ssh admin@$iocage_05 sudo service pf status | tee out/out-04.txt
ssh admin@$iocage_05 cat /etc/pf.conf | tee out/out-05.txt

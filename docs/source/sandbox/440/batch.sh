#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# ansible-playbook -i iocage.ini -t bsd_dhcpd_packages -e bsd_dhcpd_install=install pb-dhcp.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini pb-dhcp.yml | tee out/out-02.txt

ansible-playbook -i iocage.ini pb-pf-setup.yml | tee out/out-03.txt
ansible-playbook -i iocage.ini -t pf_packages -e pf_install=true pb-pf.yml | tee out/out-04.txt
ansible-playbook -i iocage.ini -e pf_enable=false pb-pf.yml | tee out/out-05.txt
ansible-playbook -i iocage.ini -t pf_rcconf_pf pb-pf.yml | tee out/out-06.txt

ssh admin@iocage_06 sudo service isc-dhcpd status | tee out/out-07.txt
ssh admin@iocage_06 cat /usr/local/etc/dhcpd.conf  | tee out/out-08.txt

ssh admin@iocage_06 sudo service pf status | tee out/out-09.txt
ssh admin@iocage_06 cat /etc/pf.conf | tee out/out-10.txt

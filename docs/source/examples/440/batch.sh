#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Install DHCP.
ansible-playbook -i iocage.ini -t bsd_dhcpd_packages -e bsd_dhcpd_install=install pb-dhcp.yml | tee out/out-01.txt

# Configure DHCP.
ansible-playbook -i iocage.ini pb-dhcp.yml | tee out/out-02.txt

# Configure PF.
ansible-playbook pb-pf-setup.yml -i iocage.ini | tee out/out-03.txt
ansible-playbook pb-pf.yml -i iocage.ini -t pf_packages -e pf_install=true | tee out/out-04.txt
ansible-playbook pb-pf.yml -i iocage.ini -e pf_enable=false | tee out/out-05.txt
ansible-playbook pb-pf.yml -i iocage.ini -t pf_rcconf_pf | tee out/out-06.txt

# Status DHCP.
ssh admin@iocage_05 sudo service isc-dhcpd status | tee out/out-07.txt
ssh admin@iocage_05 cat /usr/local/etc/dhcpd.conf  | tee out/out-08.txt

# Status PF.
ssh admin@iocage_05 sudo service pf status | tee out/out-09.txt
ssh admin@iocage_05 cat /etc/pf.conf | tee out/out-10.txt

touch .done

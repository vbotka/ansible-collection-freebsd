#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb-login.yml -i iocage.ini | tee out/out-07.txt
ansible-playbook pb-packages.yml -i iocage.ini | tee out/out-05.txt
ansible-playbook pb-loader.yml -i iocage.ini | tee out/out-04.txt
ansible-playbook pb-network.yml -i iocage.ini | tee out/out-01.txt
ansible-playbook pb-pf.yml -i iocage.ini | tee out/out-02.txt
ansible-playbook pb-zfs.yml -i iocage.ini | tee out/out-03.txt
ansible-playbook pb-iocage.yml -i iocage.ini -t freebsd_iocage_activate -e freebsd_iocage_activate=true -e freebsd_iocage_debug=true | tee out/out-06.txt
# iocage fetch --release 14.3-RELEASE | tee out/out-08.txt
ansible-playbook pb-iocage.yml -i iocage.ini -t freebsd_iocage_sanity | tee out/out-09.txt
ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook pb-all.yml -i iocage.ini | tee out/out-10.txt

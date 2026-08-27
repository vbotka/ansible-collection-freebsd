#!/usr/bin/bash

. ../defaults/batch

ansible-playbook -i iocage.ini pb-login.yml | tee out/out-01.txt
ansible-playbook -i iocage.ini pb-packages.yml | tee out/out-02.txt
ansible-playbook -i iocage.ini pb-loader.yml | tee out/out-03.txt
ansible-playbook -i iocage.ini pb-network.yml | tee out/out-04.txt
# ansible-playbook -i iocage.ini pb-pf.yml | tee out/out-05.txt
ansible-playbook -i iocage.ini pb-zfs.yml | tee out/out-06.txt
ansible-playbook -i iocage.ini -t freebsd_iocage_activate -e freebsd_iocage_activate=true -e freebsd_iocage_debug=true pb-iocage.yml | tee out/out-07.txt
# iocage fetch --release 15.1-RELEASE | tee out/out-08.txt
ansible-playbook -i iocage.ini -t freebsd_iocage_sanity pb-iocage.yml | tee out/out-09.txt
ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook -i iocage.ini pb-all.yml | tee out/out-10.txt

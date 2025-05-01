#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb-postinstall.yml -i iocage-hosts.ini -l iocage_03 -t fp_resolvconf -e fp_resolvconf_conf_clean=true -e fp_resolv_conf_clean=true | tee out/out-01.txt
ansible-playbook pb-network.yml -i iocage-hosts.ini -l iocage_03 | tee out/out-02.txt

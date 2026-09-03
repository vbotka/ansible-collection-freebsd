#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Create repos
ansible-playbook -i iocage.ini -t pkg_conf,pkg_fetch pb-packages.yml | tee out/out-01.txt

# Configure Nginx
ansible-playbook -i iocage.ini pb-nginx.yml | tee out/out-02.txt

ssh admin@iocage_06 cat /usr/local/etc/pkg/repos/local.conf | tee out/out-03.txt
ssh admin@iocage_06 fetch -qo - http://localhost | tee out/out-04.txt

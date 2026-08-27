#!/usr/bin/bash

. ../defaults/batch

# Create repos
ansible-playbook pb.yml -i iocage.ini -t pkg_keys,pkg_conf | tee out/out-01.txt

ssh admin@$iocage_04 cat /usr/local/etc/pkg/repos/build.conf | tee out/out-02.txt
ssh admin@$iocage_04 sudo pkg -vv | tee out/out-03.txt
ssh admin@$iocage_04 sudo pkg update -f | tee out/out-04.txt

#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 -t cimage_debug -e cimage_debug=true | tee out/out-01.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 -t cimage_download -e cimage_download=true | tee out/out-02.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 -t cimage_unpack -e cimage_unpack=true | tee out/out-03.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 -t cimage_mount | tee out/out-04.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 -t cimage_customize | tee out/out-05.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 -t cimage_umount | tee out/out-06.txt
ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_02 | tee out/out-07.txt
# ssh freebsd@10.1.0.16 dmesg | tee out/out-08.txt
# sed -E -i "s/[0-9a-fA-F:]{17}/11:22:33:44:55:66/" out/out-08.txt

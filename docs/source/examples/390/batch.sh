#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_debug -e poudriere_debug=true | tee out/out-01.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_pkg -e poudriere_install=true | tee out/out-02.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_dirs | tee out/out-03.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_key | tee out/out-04.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_cert -e poudriere_cert=true | tee out/out-05.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_conf | tee out/out-06.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_pkglists | tee out/out-07.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_make | tee out/out-08.txt
ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -e poudriere_install=true -e poudriere_cert=true  | tee out/out-09.txt
#
ssh admin@$build_example_com sudo tree /usr/local/etc/ssl/ | tee out/out-10.txt
ssh admin@$build_example_com cat /usr/local/etc/poudriere.conf | tee out/out-11.txt
ssh admin@$build_example_com tree /usr/local/etc/poudriere.d/pkglist | tee out/out-12.txt
ssh admin@$build_example_com cat /usr/local/etc/poudriere.d/pkglist/amd64/ansible | tee out/out-13-amd64.txt
ssh admin@$build_example_com cat /usr/local/etc/poudriere.d/pkglist/amd64/minimal | tee out/out-14-amd64.txt
ssh admin@$build_example_com cat /usr/local/etc/poudriere.d/pkglist/arm/ansible | tee out/out-13-arm.txt
ssh admin@$build_example_com cat /usr/local/etc/poudriere.d/pkglist/arm/minimal | tee out/out-14-arm.txt
ssh admin@$build_example_com cat /usr/local/etc/poudriere.d/make.conf | tee out/out-15.txt
#
ansible-playbook pb-postinstall.yml -i build-hosts.ini -l build.example.com -t fp_packages | tee out/out-16.txt
ansible-playbook pb-postinstall.yml -i build-hosts.ini -l build.example.com -t fp_qemu | tee out/out-17.txt
#
ssh admin@$build_example_com /usr/local/etc/rc.d/qemu_user_static list | tee out/out-19.txt
# ssh admin@$build_example_com sudo ... | tee out/out-20.txt

#!/usr/bin/bash

. ../defaults/batch

ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -l | tee out/out-01.txt

ansible-playbook pb-pkg-update.yml -i iocage.ini -l iocage_02 -e debug=true | tee out/out-02.txt
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-03.txt
ansible-playbook pb-test-01.yml -i hosts -l test_111 -t pkg_debug -e pkg_debug=true | tee out/out-04.txt
ansible-playbook pb-test-01.yml -i hosts -i iocage.ini | tee out/out-05.txt
ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -l test_111 -e pkg_debug=true | tee out/out-06.txt
ansible-playbook pb-test-01.yml -i hosts -t pkg_stat -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true | tee out/out-07.txt
ansible-playbook pb-test-02.yml -i iocage.ini -l iocage_02 -t pkg_stat -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true | tee out/out-08.txt

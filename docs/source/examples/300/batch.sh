#!/usr/bin/bash

. ../defaults/batch

ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts --graph | tee out/out-02.txt

ansible-playbook pb-test-01.yml -i hosts | tee out/out-03.txt
ansible-playbook pb-test-02.yml -i iocage.ini -l iocage_02 -e debug=true | tee out/out-04.txt
ansible-playbook pb-test-03.yml -i iocage.ini -l iocage_02 -e debug=true | tee out/out-05.txt
ansible-playbook pb-test-04.yml -i iocage.ini -l iocage_02 | tee out/out-06.txt
ansible-playbook pb-test-05.yml -i iocage.ini -l iocage_02 | tee out/out-07.txt
ansible-playbook pb-test-06.yml -i hosts | tee out/out-08.txt
ansible-playbook pb-test-07.yml -i iocage.ini | tee out/out-09.txt

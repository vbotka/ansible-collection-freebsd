#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
echo admin | ssh admin@$iocage_01 sudo -S iocage destroy -f ansible_client
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage destroy -f ansible_client
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# prepare
(cd ../202 && ansible-playbook pb-iocage-template.yml -i iocage.ini)
(cd ../207 && ansible-playbook pb-iocage-project-create.yml -i iocage.ini -i hosts)

# status of the project
ansible-playbook pb-all-groups.yml -i hosts --flush-cache | tee out/out-01.txt

# Create Log Server
ansible-playbook pb-logserv.yml -i hosts -e install=true | tee out/out-02.txt

# Create Log Clients
ansible-playbook pb-logclient.yml -i hosts -i iocage.ini -e install=true -e debug=true | tee out/out-03.txt

# Test
ansible-playbook pb-test-logclient.yml -i hosts | tee out/out-04.txt

# ansible-playbook -i hosts -i iocage.ini pb-iocage-project-destroy.yml -e debug=true | tee out/out-06.txt
# ansible-playbook -i hosts pb-test-all.yml --flush-cache | tee out/out-07.txt

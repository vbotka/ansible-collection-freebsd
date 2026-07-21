#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook  -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_destroy_all_jails.yml
# ssh admin@iocage_06 sudo iocage destroy -f ansible_client

# prepare
(cd ../202 && ansible-playbook -i iocage.ini --flush-cache vbotka.freebsd.pb_iocage_template.yml)
(cd ../202 && ansible-playbook -i iocage.ini -t clone -e clone=true vbotka.freebsd.pb_iocage_ansible_clients.yml)

# status of jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts --graph | tee out/out-02.txt

# display sshd rcvar
ansible-playbook pb-test-01.yml -i hosts | tee out/out-03.txt

# display dictionary jid_rcvar
ansible-playbook -i iocage.ini -e debug=true pb-test-02.yml | tee out/out-04.txt

# display enabled services
ansible-playbook -i iocage.ini -e debug=true pb-test-03.yml | tee out/out-05.txt

# display sshd status
ansible-playbook -i iocage.ini pb-test-04.yml | tee out/out-06.txt

# display sshd commands synopsis
ansible-playbook -i iocage.ini pb-test-05.yml | tee out/out-07.txt

# display sendmail rcvars
ansible-playbook -i hosts pb-test-06.yml | tee out/out-08.txt

# start apcupsd
ansible-playbook -i iocage.ini -e debug=true pb-test-07.yml | tee out/out-09.txt

# module vbotka.freebsd.service examples
ansible-playbook -i iocage.ini -i hosts pb-examples.yml

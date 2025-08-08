#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# prepare
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -l iocage_04)
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -t clone -e clone=true -i iocage.ini -l iocage_04)

# status of jails
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts --graph | tee out/out-02.txt

# display sshd rcvar
ansible-playbook pb-test-01.yml -i hosts | tee out/out-03.txt
# display dictionary jid_rcvar
ansible-playbook pb-test-02.yml -i iocage.ini -e debug=true | tee out/out-04.txt
# display enabled services
ansible-playbook pb-test-03.yml -i iocage.ini -e debug=true | tee out/out-05.txt
# display sshd status
ansible-playbook pb-test-04.yml -i iocage.ini | tee out/out-06.txt
# display sshd commands synopsis
ansible-playbook pb-test-05.yml -i iocage.ini | tee out/out-07.txt
# display sendmail rcvars
ansible-playbook pb-test-06.yml -i hosts | tee out/out-08.txt
# start apcupsd
ansible-playbook pb-test-07.yml -i iocage.ini | tee out/out-09.txt

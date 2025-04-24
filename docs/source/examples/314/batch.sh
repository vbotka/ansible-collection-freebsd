#!/usr/bin/bash
. ../defaults/batch
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage-hosts.ini
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage-hosts.ini -l iocage_02 -t swarm -e swarm=true | tee out/out-11.txt
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_update_repos.yml -i iocage-hosts.ini -l iocage_02 | tee out/out-12.txt
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts -i iocage-hosts.ini --graph | tee out/out-02.txt
ansible-playbook pb-install.yml -i hosts -i iocage-hosts.ini | tee out/out-03.txt
ansible-playbook pb.yml -i hosts -t rsnapshot_debug -e rsnapshot_debug=true | tee out/out-04.txt
ansible-playbook pb.yml -i hosts | tee out/out-05.txt

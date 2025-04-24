#!/usr/bin/bash
. ../defaults/batch
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage-hosts.ini
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage-hosts.ini -l iocage_02 -t swarm -e swarm=true | tee out/out-11.txt
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_update_repos.yml -i iocage-hosts.ini -l iocage_02 | tee out/out-12.txt
ssh admin@$iocage_02 sudo CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts -i iocage-hosts.ini --graph | tee out/out-02.txt
# ansible-playbook pb.yml -i hosts -t cl_setup -e cl_setup=true | tee out/out-03.txt
# ansible-playbook pb.yml -i hosts -t cl_sanity -e cl_sanity=true | tee out/out-04.txt
# ansible-playbook pb.yml -i hosts -l test_111 -t cl_debug -e cl_debug=true | tee out/out-05.txt
# ansible-playbook pb.yml -i hosts -i iocage-hosts.ini -t cl_packages -e cl_install=true | tee out/out-06.txt
# ansible-playbook pb.yml -i hosts -t cl_states | tee out/out-07.txt
# ansible-playbook pb.yml -i hosts -t cl_files | tee out/out-08.txt
# ansible-playbook pb.yml -i hosts -t cl_services | tee out/out-09.txt
ansible-playbook pb.yml -i hosts -i iocage-hosts.ini | tee out/out-10.txt

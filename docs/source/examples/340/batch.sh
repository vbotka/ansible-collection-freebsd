#!/usr/bin/bash

. ../defaults/batch

# destroy
VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini
ssh admin@$iocage_04 sudo iocage destroy -f ansible_client

# create template
(cd ../202 && ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini -l iocage_04)

# create jails
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t swarm -e swarm=true --flush-cache | tee out/out-11.txt

# status of jails
ssh admin@$iocage_04 sudo iocage list -l | tee out/out-01.txt
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-02.txt

# update repos
ansible-playbook vbotka.freebsd.pb_iocage_update_repos.yml -i iocage.ini | tee out/out-12.txt

# install and configure lighttpd
ansible-playbook pb.yml -i hosts -t cl_setup -e cl_setup=true | tee out/out-03.txt
# ansible-playbook pb.yml -i hosts -t cl_sanity -e cl_sanity=true | tee out/out-04.txt
# ansible-playbook pb.yml -i hosts -l test_111 -t cl_debug -e cl_debug=true | tee out/out-05.txt
# ansible-playbook pb.yml -i hosts -i iocage.ini -t cl_packages -e cl_install=true | tee out/out-06.txt
# ansible-playbook pb.yml -i hosts -t cl_states | tee out/out-07.txt
# ansible-playbook pb.yml -i hosts -t cl_files | tee out/out-08.txt
# ansible-playbook pb.yml -i hosts -t cl_services | tee out/out-09.txt

ansible-playbook pb.yml -i hosts -i iocage.ini | tee out/out-10.txt

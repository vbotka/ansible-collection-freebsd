#!/usr/bin/bash

. ../defaults/batch

# Update repos
ansible-playbook vbotka.freebsd.pb_iocage_update_vmm_repos.yml | tee out/out-01.txt

# install and configure lighttpd
ansible-playbook pb-config-light.yml -t cl_setup -e cl_setup=true | tee out/out-03.txt
ansible-playbook pb-config-light.yml -t cl_sanity -e cl_sanity=true | tee out/out-04.txt
ansible-playbook pb-config-light.yml -t cl_debug -e cl_debug=true | tee out/out-05.txt
ansible-playbook pb-config-light.yml -t cl_packages -e cl_install=true | tee out/out-06.txt
ansible-playbook pb-config-light.yml -t cl_states | tee out/out-07.txt
ansible-playbook pb-config-light.yml -t cl_files | tee out/out-08.txt
ansible-playbook pb-config-light.yml -t cl_services | tee out/out-09.txt

ansible-playbook pb-config-light.yml | tee out/out-10.txt

# Create Log Server
ansible-playbook pb-logserv.yml -e install=true | tee out/out-11.txt

#!/usr/bin/bash

. ../defaults/batch

# Update repos
ansible-playbook vbotka.freebsd.pb_iocage_update_vmm_repos.yml | tee out/out-01.txt

# Create Branch Server
ansible-playbook pb-config-light.yml -t cl_setup -e cl_setup=true | tee out/out-03.txt
ansible-playbook pb-config-light.yml -t cl_sanity -e cl_sanity=true | tee out/out-04.txt
ansible-playbook pb-config-light.yml -t cl_debug -e cl_debug=true | tee out/out-05.txt
ansible-playbook pb-config-light.yml -t cl_packages -e cl_install=true | tee out/out-06.txt
ansible-playbook pb-config-light.yml -t cl_states | tee out/out-07.txt
ansible-playbook pb-config-light.yml -t cl_files | tee out/out-08.txt
ansible-playbook pb-config-light.yml -t cl_services | tee out/out-09.txt

ansible-playbook pb-config-light.yml | tee out/out-10.txt

# Test service git_daemon
ssh admin@$branch_server_example_com sudo service git_daemon status | tee out/out-11.txt

# Create Log Server
ansible-playbook pb-log-server.yml -e install=true | tee out/out-12.txt

# Test service syslog-ng
ssh admin@$branch_server_example_com sudo service syslog-ng status | tee out/out-13.txt

# Create Git repos
# ansible-playbook pb-git-repos.yml | tee out/out-14.txt

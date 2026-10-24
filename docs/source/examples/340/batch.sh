#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# In batch, destroy swarms.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml
fi

# Create swarm.
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Graph.
ansible-inventory -i hosts -i iocage.ini --graph | tee out/out-02.txt

# Jails.
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Update repos.
ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_update_repos.yml | tee out/out-04.txt

# Install and configure lighttpd.
ansible-playbook -i hosts -t cl_setup -e cl_setup=true pb.yml | tee out/out-05.txt
# ansible-playbook pb.yml -i hosts -t cl_sanity -e cl_sanity=true | tee out/out-15.txt
# ansible-playbook pb.yml -i hosts -l test-111 -t cl_debug -e cl_debug=true | tee out/out-16.txt
# ansible-playbook pb.yml -i hosts -i iocage.ini -t cl_packages -e cl_install=true | tee out/out-17.txt
# ansible-playbook pb.yml -i hosts -t cl_states | tee out/out-18.txt
# ansible-playbook pb.yml -i hosts -t cl_files | tee out/out-19.txt
# ansible-playbook pb.yml -i hosts -t cl_services | tee out/out-20.txt
ansible-playbook -i hosts -i iocage.ini pb.yml | tee out/out-06.txt

# Clean up.
sudo rm conf-light/assemble/*
sudo rm ../../../../roles/config_light/handlers/*
sudo touch ../../../../roles/config_light/handlers/main.yml

# Test.
ansible-playbook -i hosts -i iocage.ini pb-test.yml | tee out/out-07.txt

# In batch, destroy swarms.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml
fi

touch .done

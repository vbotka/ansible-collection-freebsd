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

# Install packages
ansible-playbook -i hosts -i iocage.ini  pb-install.yml | tee out/out-04.txt

# Install and configure rsnapshot.
ansible-playbook -i hosts -t rsnapshot_debug -e rsnapshot_debug=true pb.yml | tee out/out-05.txt
ansible-playbook -i hosts pb.yml | tee out/out-06.txt

# In batch, destroy swarms.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ansible-playbook -i iocage.ini -t swarm_destroy -e swarm_destroy=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml
fi

touch .done

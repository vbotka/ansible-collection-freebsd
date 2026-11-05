#!/usr/bin/bash
# shellcheck disable=SC1091
. ../defaults/batch

# Destroy clones.
ssh admin@iocage_06 sudo iocage destroy -f www-4

# Create and start clones.
ansible-playbook -i iocage.ini -t clone -e clone=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails.
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Create data for Apache HTTP Server.
ansible-playbook -i hosts pb-data.yml | tee out/out-04.txt

# Configure and start Apache HTTP Server.
ansible-playbook -i hosts pb-apache.yml | tee out/out-05.txt

# Results.
ssh admin@iocage_06 "sudo iocage exec www-4 sh -c 'service apache24 configtest 2>&1'" | tee out/out-06.txt
ssh admin@iocage_06 "sudo iocage exec www-4 sh -c 'service apache24 status 2>&1'" | tee out/out-07.txt

# Destroy clones in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_06 sudo iocage destroy -f www-4
fi

touch .done

#!/usr/bin/bash
# shellcheck disable=SC1091
. ../defaults/batch

# Destroy clones.
ssh admin@iocage_06 sudo iocage destroy -f www-3

# Create and start clones.
ansible-playbook -i iocage.ini -t clone -e clone=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails.
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Display certificate variables.
ansible-playbook -i hosts -t certificate_debug -e certificate_debug=true pb-certificate.yml | tee out/out-04.txt

# Install packages, create directories, and test sanity.
ansible-playbook -i hosts -t certificate_setup pb-certificate.yml | tee out/out-05.txt

# Create OpenSSL private keys, CSRs, and certificatses by openssl_* modules.
ansible-playbook -i hosts -t certificate_openssl pb-certificate.yml | tee out/out-06.txt

# Display status of files OpenSSL private keys, CSRs, and certificates.
ansible-playbook -i hosts -t certificate_openssl_stat pb-certificate.yml | tee out/out-07.txt

# Create data for Apache HTTP Server.
ansible-playbook -i hosts pb-data.yml | tee out/out-08.txt

# Configure and start Apache HTTP Server.
ansible-playbook -i hosts pb-apache.yml | tee out/out-09.txt

# Results.
ssh admin@iocage_06 "sudo iocage exec www-3 sh -c 'service apache24 configtest 2>&1'" | tee out/out-10.txt
ssh admin@iocage_06 "sudo iocage exec www-3 sh -c 'service apache24 status 2>&1'" | tee out/out-11.txt

# Destroy clones in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_06 sudo iocage destroy -f www-3
fi

touch .done

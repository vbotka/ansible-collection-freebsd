#!/usr/bin/bash
# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Create jails
ansible-playbook -i iocage.ini -t clone_host_hostname -e clone_host_hostname=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Display certificate variables
ansible-playbook -i hosts -t certificate_debug -e certificate_debug=true --flush-cache pb-certificate.yml | tee out/out-02.txt

# Install packages, create directories, and test sanity
ansible-playbook -i hosts -t certificate_setup pb-certificate.yml | tee out/out-03.txt

# Create OpenSSL private keys, CSRs, and certificatses by openssl_* modules
ansible-playbook -i hosts -t certificate_openssl pb-certificate.yml | tee out/out-04.txt

# Display status of files OpenSSL private keys, CSRs, and certificates
ansible-playbook -i hosts -t certificate_openssl_stat pb-certificate.yml | tee out/out-05.txt

# Create Apache HTTP Server
ansible-playbook -i hosts pb-apache.yml | tee out/out-07.txt

# Create data-foo-bar
ssh -o StrictHostKeychecking=no admin@www-3 sudo cp -r /usr/local/www/apache24/data /usr/local/www/apache24/data-foo-bar

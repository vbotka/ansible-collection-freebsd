#!/usr/bin/bash
. ../defaults/batch

# Create jails
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone_host_hostname -e clone_host_hostname=true | tee out/out-01.txt

# Display certificate variables
ansible-playbook pb-certificate.yml -i hosts -t certificate_debug -e certificate_debug=true  --flush-cache | tee out/out-02.txt

# Install packages, create directories, and test sanity
ansible-playbook pb-certificate.yml -i hosts -t certificate_setup | tee out/out-03.txt

# Create OpenSSL private keys, CSRs, and certificatses by openssl_* modules
ansible-playbook pb-certificate.yml -i hosts -t certificate_openssl | tee out/out-04.txt

# Display status of files OpenSSL private keys, CSRs, and certificates
ansible-playbook pb-certificate.yml -i hosts -t certificate_openssl_stat | tee out/out-05.txt

# Create Apache HTTP Server
ansible-playbook pb-apache.yml -i hosts | tee out/out-07.txt

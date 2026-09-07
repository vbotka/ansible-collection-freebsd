#!/usr/bin/bash
# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache

# Destroy www-2
ssh admin@iocage_06 sudo iocage destroy -f www-2

# Create jails
ansible-playbook -i iocage.ini -t create_host -e create_host=true vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Display certificate variables
ansible-playbook -i hosts -t certificate_debug -e certificate_debug=true pb-certificate.yml | tee out/out-02.txt

# Install packages, create directories, and test sanity
ansible-playbook -i hosts -t certificate_setup pb-certificate.yml | tee out/out-03.txt

# Create OpenSSL private keys, CSRs, and certificatses by openssl_* modules
ansible-playbook -i hosts -t certificate_openssl pb-certificate.yml | tee out/out-04.txt

# Display status of files OpenSSL private keys, CSRs, and certificates
ansible-playbook -i hosts -t certificate_openssl_stat pb-certificate.yml | tee out/out-05.txt

# Dump the certificate
ssh admin@iocage_06 sudo iocage exec www-5 -- 'openssl x509 -in /usr/local/etc/ssl/certs/build.foo.bar.crt -text -noout -certopt no_pubkey,no_sigdump' | tee out/out-06.txt

# Create Apache HTTP Server
ansible-playbook -i hosts pb-apache.yml | tee out/out-07.txt

# Inventory graph
ansible-inventory -i hosts --graph | tee out/out-08.txt

# List jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-09.txt

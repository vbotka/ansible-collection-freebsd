#!/usr/bin/bash

. ../defaults/batch

# Display certificate variables
ansible-playbook pb-certificate.yml -t certificate_debug -e certificate_debug=true | tee out/out-01.txt

# Install packages, create directories, and test sanity
ansible-playbook pb-certificate.yml -t certificate_setup | tee out/out-02.txt

# Create OpenSSL private keys, CSRs, and certificatses by openssl_* modules
ansible-playbook pb-certificate.yml -t certificate_openssl | tee out/out-03.txt

# Display status of files OpenSSL private keys, CSRs, and certificates
ansible-playbook pb-certificate.yml -t certificate_openssl_stat | tee out/out-04.txt

# Create Apache HTTP Server
ansible-playbook pb-apache.yml -e install=true | tee out/out-05.txt

# Create Log Server
ansible-playbook pb-logserv.yml -e install=true | tee out/out-06.txt

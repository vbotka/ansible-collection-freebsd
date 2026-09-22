#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy www-01 and www-02
ssh admin@iocage_06 sudo iocage destroy -f www-01
ssh admin@iocage_06 sudo iocage destroy -f www-02
ssh admin@iocage_06 sudo iocage destroy -f www-03

# Create the project
ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-01.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Get Nginx inventory alias and IP.
# ansible-playbook -i hosts pb-nginx-test-ip.yml

# Configure Nginx servers
ansible-playbook -i hosts pb-nginx.yml | tee out/out-04.txt

# Configure HAProxy
ansible-playbook -i iocage.ini -i hosts pb-haproxy.yml | tee out/out-05.txt

# Test HAProxy
ssh admin@iocage_06 'bash -s' < test-haproxy.sh | tee out/out-06.txt

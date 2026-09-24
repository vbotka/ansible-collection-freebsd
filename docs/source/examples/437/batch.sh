#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Stop Nginx. Port 80 conflict with HAProxy
ssh admin@iocage_06 sudo service nginx stop
ssh admin@iocage_06 sudo service nginx status

# Destroy www-01 and www-02
ssh admin@iocage_06 sudo iocage destroy -f www-01
ssh admin@iocage_06 sudo iocage destroy -f www-02
ssh admin@iocage_06 sudo iocage destroy -f www-03

# Swarm
ansible-playbook -i iocage.ini -t swarm -e swarm=true -e iocage_jails_source=inventory vbotka.freebsd.pb_iocage_ansible_clients.yml | tee out/out-01.txt

# Graph
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails
ssh admin@iocage_06 sudo iocage list -l | tee out/out-03.txt

# Get Nginx inventory alias and IP.
# ansible-playbook -i hosts pb-nginx-test-ip.yml

# Configure Nginx cluster
ansible-playbook -i hosts pb-nginx.yml | tee out/out-04.txt

# Configure HAProxy
ansible-playbook -i iocage.ini -i hosts pb-haproxy.yml | tee out/out-05.txt
ssh admin@iocage_06 sudo service haproxy status

# Test HAProxy
ssh admin@iocage_06 'bash -s' < test-haproxy.sh | tee out/out-06.txt

# Stop HAProxy (local repo Nginx is running on port 80)
ssh admin@iocage_06 sudo service haproxy stop
ssh admin@iocage_06 sudo service haproxy status

# Start Nginx. Port 80 conflict with HAProxy
ssh admin@iocage_06 sudo service nginx start
ssh admin@iocage_06 sudo service nginx status

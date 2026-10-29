#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Stop Nginx. Port 80 conflict with HAProxy.
ssh admin@iocage_05 sudo service nginx stop
ssh admin@iocage_05 sudo service nginx status
ssh admin@iocage_06 sudo service nginx stop
ssh admin@iocage_06 sudo service nginx status

# Destroy jails.
cleanup_iocage_test_jails -i "5 6" -n "11 12 13" -p www

# Project.
ansible-playbook -i hosts -i iocage.ini vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-01.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-03.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Get Nginx inventory alias and IP.
# ansible-playbook -i hosts pb-nginx-test-ip.yml

# Configure Nginx cluster.
ansible-playbook -i hosts pb-nginx.yml | tee out/out-05.txt

# Install and configure HAProxy.
ansible-playbook -i hosts -i iocage.ini pb-haproxy.yml | tee out/out-06.txt

# Test configuration.
ssh admin@iocage_05 sudo service haproxy configtest 2>&1 | tee out/out-07.txt
ssh admin@iocage_06 sudo service haproxy configtest 2>&1 | tee out/out-08.txt

# Test status.
ssh admin@iocage_05 sudo service haproxy status 2>&1 | tee out/out-09.txt
ssh admin@iocage_06 sudo service haproxy status 2>&1 | tee out/out-10.txt

# Test HAProxy.
ssh admin@iocage_05 'bash -s -- 172.16.95.1' < test-haproxy.sh | tee out/out-11.txt
ssh admin@iocage_06 'bash -s -- 172.16.99.1' < test-haproxy.sh | tee out/out-12.txt

# Destroy the jails in batch.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    cleanup_iocage_test_jails -i "5 6" -n "11 12 13" -p www
fi

# Stop HAProxy (local repo Nginx is running on port 80).
ssh admin@iocage_05 sudo service haproxy stop
ssh admin@iocage_06 sudo service haproxy stop
sleep 2

# Start Nginx. Port 80 conflict with HAProxy.
ssh admin@iocage_05 sudo service nginx start
ssh admin@iocage_06 sudo service nginx start
ssh admin@iocage_05 sudo service nginx status
ssh admin@iocage_06 sudo service nginx status

touch .done

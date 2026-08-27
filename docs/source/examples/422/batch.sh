#!/usr/bin/bash
. ../defaults/batch

# Destroy jails
# VBOTKA_FREEBSD_BATCH=true ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml -i iocage.ini --flush-cache
x
# Create jails
ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini -t clone_host_hostname -e clone_host_hostname=true | tee out/out-01.txt

# Create Apache HTTP Server
ansible-playbook pb-apache.yml -i hosts --flush-cache | tee out/out-02.txt

# Copy info.php to /usr/local/www/apache24/data/ and restart server
scp -o StrictHostKeychecking=no files/info.php admin@www-4:/tmp
ssh -o StrictHostKeychecking=no admin@www-4 sudo mv /tmp/info.php /usr/local/www/apache24/data/

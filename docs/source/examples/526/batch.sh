#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails. (log-server-*, www-*)
ssh admin@iocage_05 sudo iocage destroy -f log-server-01
ssh admin@iocage_06 sudo iocage destroy -f log-server-02
ssh admin@iocage_05 sudo iocage destroy -f www-01
ssh admin@iocage_06 sudo iocage destroy -f www-02

# Create jails.
ansible-playbook -i hosts -i iocage.ini vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-01.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-02.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-03.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-04.txt

# Test. Adjust the sleep time to your system. Most of the time is consumed by
# installing the packages. If you schedule ansible_pull at=now add 90 to sleep
# for cron.
sleep 50
ansible-playbook -i hosts pb-logserver-test.yml | tee out/out-05.txt
ansible-playbook -i hosts pb-logclient-test.yml | tee out/out-06.txt

# In batch, stop and destroy jails.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    ssh admin@iocage_05 sudo iocage destroy -f log-server-01
    ssh admin@iocage_06 sudo iocage destroy -f log-server-02
    ssh admin@iocage_05 sudo iocage destroy -f www-01
    ssh admin@iocage_06 sudo iocage destroy -f www-02
fi

touch .done

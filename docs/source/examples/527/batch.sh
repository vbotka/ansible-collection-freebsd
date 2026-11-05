#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails. (pkg-repo)
ssh admin@iocage_05 sudo iocage stop pkg-repo
ssh admin@iocage_06 sudo iocage stop pkg-repo
ssh admin@iocage_05 sudo iocage destroy -f pkg-repo
ssh admin@iocage_06 sudo iocage destroy -f pkg-repo

# In batch, manage templates.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    # Destroy templates.
    ssh admin@iocage_05 sudo iocage destroy -f ansible-pkg-repo
    ssh admin@iocage_06 sudo iocage destroy -f ansible-pkg-repo
    # Create templates.
    ansible-playbook -i iocage.ini pb-iocage-template.yml | tee out/out-01.txt
fi

# Templates.
ssh admin@iocage_05 sudo iocage list -lt | tee out/out-02.txt
ssh admin@iocage_06 sudo iocage list -lt | tee out/out-03.txt

# Create project.
ansible-playbook -i hosts -i iocage.ini vbotka.freebsd.pb_iocage_project_create_from_templates.yml | tee out/out-04.txt

# Graph.
ansible-inventory -i hosts --graph | tee out/out-05.txt

# Jails.
ssh admin@iocage_05 sudo iocage list -l | tee out/out-06.txt
ssh admin@iocage_06 sudo iocage list -l | tee out/out-07.txt

# Fetch packages.
ansible-playbook -i hosts/05_iocage2.yml -i hosts/99_constructed.yml pb-pkg-repo.yml | tee out/out-08.txt
ansible-playbook -i hosts/06_iocage2.yml -i hosts/99_constructed.yml pb-pkg-repo.yml | tee out/out-09.txt

# List pkg-repo.
ssh admin@iocage_05 fetch -qo - http://172.16.95.23/ | tee out/out-10.txt
ssh admin@iocage_06 fetch -qo - http://172.16.99.23/ | tee out/out-11.txt

touch .done

#!/usr/bin/bash

# shellcheck disable=SC1091
. ../defaults/batch

# Destroy jails. (repos, repos-devel)
ssh admin@iocage_05 sudo iocage destroy -f repos
ssh admin@iocage_05 sudo iocage destroy -f repos-devel
ssh admin@iocage_06 sudo iocage destroy -f repos
ssh admin@iocage_06 sudo iocage destroy -f repos-devel

# In batch, manage templates.
if [ "${VBOTKA_FREEBSD_BATCH:-}" = "true" ]; then
    # Destroy templates.
    ssh admin@iocage_05 sudo iocage destroy -f ansible-repos
    ssh admin@iocage_06 sudo iocage destroy -f ansible-repos
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

# Clone repos.
ansible-playbook -i hosts/05_iocage2.yml -i hosts/99_constructed.yml pb-repos.yml | tee out/out-08.txt
ansible-playbook -i hosts/06_iocage2.yml -i hosts/99_constructed.yml pb-repos.yml | tee out/out-09.txt

# List repos.
ssh admin@iocage_05 sudo iocage exec repos ls -la /usr/local/git | tee out/out-10.txt
ssh admin@iocage_06 sudo iocage exec repos ls -la /usr/local/git | tee out/out-11.txt

touch .done

#!/usr/bin/bash
. ../defaults/batch
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_debug -e poudriere_debug=true | tee out/out-01.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_pkg -e poudriere_install=true | tee out/out-02.txt
ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_dirs | tee out/out-03.txt

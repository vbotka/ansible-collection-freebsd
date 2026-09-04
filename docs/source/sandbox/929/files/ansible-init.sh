#!/bin/sh
#
# PROVIDE: ansible_init
# REQUIRE: FILESYSTEMS NETWORKING
# KEYWORD: firstboot

. /etc/rc.subr

name="ansible_init"
desc="Firstboot ansible-pull initialization"
rcvar="ansible_init_enable"

# Default configuration settings
: ${ansible_init_enable:="NO"}
: ${ansible_init_host:="http://localhost"}
: ${ansible_init_repo:="ansible-conf-init"}
: ${ansible_init_dest:="/root"}
: ${ansible_init_vars:="/root/ansible-vars"}
: ${ansible_init_playbook:="pb-init.yml"}

# Define the command to run
command="/usr/local/bin/ansible-pull"

# Pass the environment variables
ansible_init_env="\
    PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8"

# Construct the arguments
load_rc_config $name
command_args="\
    -i hosts \
    -U ${ansible_init_host}/${ansible_init_repo} \
    -d ${ansible_init_dest}/${ansible_init_repo} \
    -e 'ai_vars=${ansible_init_vars}' \
    -e 'ai_pull_mode=true' \
    ${ansible_init_playbook}"

run_rc_command "$1"

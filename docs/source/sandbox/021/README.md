# Inventory plugin iocage2

Use the jails created in 020.

## Example in UG Plugins -> jailexec

shell> ansible-inventory -i hosts.ini --graph
@all:
  |--@ungrouped:
  |--@vmm_iocage_06:
  |  |--log-server-01
  |  |--pkg-repo
  |  |--repos
(penv) > ansible-inventory -i hosts.iocage2.yml --graph
@all:
  |--@ungrouped:
  |--@vmm_iocage_06:
  |  |--repos-devel
  |  |--pkg-repo
  |  |--log-server-01
  |  |--repos

Both options give the same result:

shell> ansible-playbook -i hosts.ini pb-test-connection.yml
shell> ansible-playbook -i hosts.iocage2.yml pb-test-connection2.yml

PLAY [Test connection and get hostname.] ***************************************

TASK [command] *****************************************************************
changed: [pkg-repo]
changed: [repos]
changed: [log-server-01]
changed: [repos-devel]

TASK [debug] *******************************************************************
ok: [repos-devel] => 
    hostname: repos-devel
ok: [repos] => 
    hostname: repos
ok: [pkg-repo] => 
    hostname: pkg-repo
ok: [log-server-01] => 
    hostname: log-server-01

PLAY RECAP *********************************************************************
log-server-01              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
pkg-repo                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
repos                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
repos-devel                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

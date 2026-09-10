# Inventory plugin iocage2

Use the jails created in 020.

## Example in UG Plugins -> jailexec

(env) > ansible-inventory -i hosts.ini --graph
@all:
  |--@ungrouped:
  |--@vmm_iocage_06:
  |  |--log_server_01
  |  |--pkg_repo
  |  |--repos

(env) > ansible-inventory -i hosts.iocage2.yml --graph
@all:
  |--@ungrouped:
  |--@vmm_iocage_06:
  |  |--repos
  |  |--repos_devel
  |  |--pkg_repo
  |  |--log_server_01

Both options give the same result:

(env) > ansible-playbook -i hosts.ini pb-test-connection.yml
(env) > ansible-playbook -i hosts.iocage2.yml pb-test-connection2.yml

PLAY [Test connection and get hostname.] ****************************************************

TASK [command] ******************************************************************************
changed: [pkg_repo]
changed: [log_server_01]
changed: [repos]
changed: [repos_devel]

TASK [debug] ********************************************************************************
ok: [repos_devel] => 
    hostname: repos-devel
ok: [pkg_repo] => 
    hostname: pkg-repo
ok: [repos] => 
    hostname: repos
ok: [log_server_01] => 
    hostname: log-server-01

PLAY RECAP **********************************************************************************
log_server_01              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
pkg_repo                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
repos                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
repos_devel                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

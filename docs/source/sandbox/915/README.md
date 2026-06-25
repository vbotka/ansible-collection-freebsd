# Template ansible-syslogng-client

## syslog-ng-client.yml

The configuration syslog-ng-client.yml is NOT identical with the repo
https://github.com/vbotka/ansible-conf-syslogng-client/

The repo is used by ansible-pull started from the service ansible_init. A jail
does not know which host it is running on.

* The log_server IP here is {{ project_hosts[iocage_tags.vmm]['log_server'] }}

* The log_server IP in the repo is {{ project_hosts.log_server }}

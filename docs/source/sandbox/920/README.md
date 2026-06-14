# Template ansible_init

Use ai_db_class from the repo ansible-conf-init

```yaml
ai_db_class:
  log-server:
    repo_host: git://10.10.99.201
    repo: ansible-conf-syslogng-server
    repo_dest: /root
    repo_playbook: pb-logserv.yml
  log-client:
    repo_host: git://10.10.99.201
    repo: ansible-conf-syslogng-client
    repo_dest: /root
    repo_playbook: pb-logclient.yml

ai_db_class_options:
  at: ''
  async: true
```

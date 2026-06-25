# Template ansible-init

Use ai_db_host from the repo ansible-conf-init

```yaml
ai_db_host:
  foo:
    repo_host: "git://{{ project_hosts.repos }}"
    repo: ansible-conf-test
    repo_dest: /root
    repo_playbook: pb-test.yml
  bar:
    repo_host: "git://{{ project_hosts.repos }}"
    repo: ansible-conf-test
    repo_dest: /root
    repo_playbook: pb-test.yml
```

# Repo ansible-conf-roles

Use ai_db_class for the repo ansible-conf-init

```yaml
ai_db_class:
  log-server:
    repo_host: "git://{{ project_hosts.repos }}"
    repo: ansible-conf-roles
    repo_dest: /root
    repo_playbook: pb-roles.yml
  log-client:
    repo_host: "git://{{ project_hosts.repos }}"
    repo: ansible-conf-roles
    repo_dest: /root
    repo_playbook: pb-roles.yml
```

# freebsd_haproxy

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-haproxy)](https://github.com/vbotka/ansible-freebsd-haproxy/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.haproxy](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/haproxy/)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_haproxy/) FreeBSD. Install, configure, and run HAProxy.


## Requirements

### Collections

- community.general
- vbotka.freebsd


## Variables

Review defaults and examples in vars.


## Workflow

1) Change shell to /bin/sh

```bash
shell> ansible haproxy -e 'ansible_shell_type=csh ansible_shell_executable=/bin/csh' -a 'sudo pw usermod freebsd -s /bin/sh'
```

2) Install the role and collections

```bash
shell> ansible-galaxy role install vbotka.freebsd_haproxy
```

3) Install the collections

```bash
shell> ansible-galaxy collection install community.general
shell> ansible-galaxy collection install vbotka.freebsd
```

4) Change variables

- Review *defaults*
- Customize variables

5) Create the playbook *haproxy.yml*

```yaml
- hosts: haproxy
  roles:
    - vbotka.freebsd_haproxy
```

6) Create the inventory file *hosts*

```ini
[haproxy]
<haproxy-ip-or-fqdn>
[haproxy:vars]
ansible_connection=ssh
ansible_user=freebsd
ansible_become=yes
ansible_become_method=sudo
ansible_python_interpreter=auto_silent
```

7) Install and configure Haproxy

```bash
shell> ansible-playbook haproxy.yml
```

## References

- [HAProxy Documentation](http://haproxy.org/)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)

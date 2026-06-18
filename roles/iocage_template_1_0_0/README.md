# freebsd_iocage_template

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-iocage-template)](https://github.com/vbotka/ansible-freebsd-iocage-template/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.iocage_template](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template)

[Ansible role.](https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_iocage_template/) FreeBSD. Install, configure, and run iocage.

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-freebsd-iocage-template/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements

TBD

### Collections

* [ansible.posix](https://github.com/ansible-collections/ansible.posix)
* [community.general](https://github.com/ansible-collections/community.general)


### Recommended roles

TBD

### Packages

Controller:

TBD

Remote hosts:

TBD

## Variables

See the defaults.

```yaml
fit_debug: false
fit_debug2: false
fit_pkg_install: false
fit_sudo: false
fit_stop: true
fit_template: true
fit_templates: []
```


## Workflow

1) Change shell on the remote host to /bin/sh if necessary

```bash
shell> ansible host -e 'ansible_shell_type=csh' \
                    -e 'ansible_shell_executable=/bin/csh' \
                    -a 'sudo pw usermod admin -s /bin/sh'
```

2) Install the role.

```bash
shell> ansible-galaxy role install vbotka.freebsd_iocage_template
```

Install or update the collections if necessary

```bash
shell> ansible-galaxy collection install ansible.posix
shell> ansible-galaxy collection install community.general
```

3) Fit variables to your needs.


4) Create playbook and inventory

```bash
shell> cat iocage_template.yml
- hosts: host
  roles:
    - vbotka.freebsd_iocage_template
```

```bash
shell> cat hosts
[host]
<host-ip-or-fqdn>
[host:vars]
ansible_connection=ssh
ansible_user=admin
ansible_become=true
ansible_become_method=sudo
ansible_python_interpreter=/usr/local/bin/python3.11
```

5) Install and configure the iocage host

Add `-e fit_debug=true` to see details in the commands below. Some tasks provide
additional details when you set `-e fit_debug2=true`.

Check syntax of the play

```bash
shell> ansible-playbook iocage_template.yml --syntax-check
```

Display variables

```bash
shell> ansible-playbook iocage_template.yml -t fit_debug -e fit_debug=true
```

Dry-run the play and display the potential differences

```bash
shell> ansible-playbook iocage_template.yml -CD
```

Run the playbook. The role is idempotent. If you're sure the configuration is correct you
can run the complete play

```bash
shell> ansible-playbook iocage_template.yml
```


## Ansible lint

Use the configuration file *.ansible-lint.local* when running *ansible-lint*. Some rules
might be disabled and some warnings might be ignored. See the notes in the configuration
file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## References

- [FreeBSD handbook: Jails](https://docs.freebsd.org/en/books/handbook/jails/)
- [iocage - documentation](https://iocage.readthedocs.io/en/latest/)
- [GitHub: iocage](https://github.com/iocage/iocage)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)

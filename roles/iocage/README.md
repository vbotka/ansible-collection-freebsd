# iocage

Ansible role. Manage FreeBSD Jails by iocage.
Collection: vbotka.freebsd

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-collection-freebsd/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements and dependencies

### Collections

- [community.general](https://galaxy.ansible.com/community/general)

### Packages

- [iocage](https://www.freshports.org/sysutils/iocage/)
- [uclcmd](https://www.freshports.org/devel/uclcmd/)


## Role Variables

- See default variables in *defaults/main.yml*
- See examples in *vars/main.yml*

### freebsd_flavors_enable (default: False)

This variable enables the flavors stored in *freebsd_flavors*. By default the flavors are
disabled. This means that the default flavors from */etc/make.conf* will be installed. Enable this
variable only if *freebsd_install_method=packages*. Ports won't recognize the flavors and the
installation will crash.

### iocage_sanity_packages (default: True)

This variable enables the testing of the packages installed. By default the flavor
*iocage_python_version* is required. The default is the version of *ansible_python_version*.


## Workflow

- Install the collection and dependencies

- Create playbook

```
shell> cat playbook.yml
- hosts: srv.example.com
  collections:
    - vbotka.freebsd
  roles:
    - iocage
```

- Display help

```
shell> ansible-playbook playbook.yml
```

- Run setup tasks and test sanity

```
shell> ansible-playbook playbook.yml -t iocage_debug -e iocage_debug=true
shell> ansible-playbook playbook.yml -t iocage_packages -e iocage_install=true
shell> ansible-playbook playbook.yml -t iocage_config -e iocage_conf=true
shell> ansible-playbook playbook.yml -t iocage_activate -e iocage_activate=true
shell> ansible-playbook playbook.yml -t iocage_sanity -e iocage_sanity=true

```

- Manage jails

```
shell> ansible-playbook playbook.yml -t iocage_mng
shell> ansible-playbook playbook.yml -t iocage_info
```


## References

- [iocage - A FreeBSD Jail Manager](https://iocage.readthedocs.io/en/latest/index.html)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author

[Vladimir Botka](https://botka.link)

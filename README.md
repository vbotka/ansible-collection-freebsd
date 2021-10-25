# Ansible collection vbotka.freebsd

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-collection-freebsd/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Install

Before using this collection, you need to install it with the Ansible Galaxy command-line tool

```
shell> ansible-galaxy collection install vbotka.freebsd
```


## Setup

The only included role is iocage. See lists of tested modules and roles in
playbooks/vars/bsd-modules.yml and bsd-roles.yml. Fit the playbook variables *bsd_modules_setup* and
*bsd_roles_setup* to your needs, and install other roles and modules

```
shell> ansible-playbook vbotka.freebsd.setup.yml
```

If you want to install all tested modules and roles run

```
shell> ansible-playbook vbotka.freebsd.setup.yml -e "bsd_roles_setup=ALL bsd_roles_setup=ALL"
```


## Playbooks

* setup.yml - Setup the collection


## Roles

### Included in the collection

* iocage.yml - Manage FreeBSD Jails by iocage

### Installed by default. See variable *bsd_roles_setup*

* [ansible](https://github.com/vbotka/ansible-ansible)
* [ansible_lib](https://github.com/vbotka/ansible-lib)
* [ansible_lint](https://github.com/vbotka/ansible-lint)
* [ansible_runner](https://github.com/vbotka/ansible-runner)
* [config_light](https://github.com/vbotka/ansible-config-light)


## Modules

### Installed by default. See variable *bsd_modules_setup*

* [iocage](https://github.com/vbotka/ansible-iocage) - Jail manager using ZFS and VNET
* [ucl](https://github.com/vbotka/ansible-ucl) - Tool for working with UCL config files


## Filters

TBD.


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author

[Vladimir Botka](https://botka.link)

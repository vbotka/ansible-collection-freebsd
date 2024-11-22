# Ansible collection vbotka.freebsd

[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-collection-freebsd)](https://github.com/vbotka/ansible-collection-freebsd/tags)

[Ansible collection vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-collection-freebsd/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Setup

The collection is distributed without modules. Install the modules

```
shell> ansible-playbook vbotka.freebsd.setup.yml

```

## Playbooks

* setup.yml - Setup the collection


## Roles

* devel.yml - Setup development versions
* iocage.yml - Manage FreeBSD Jails by iocage


## Modules

* iocage - jail manager using ZFS and VNET
* ucl - tool for working with UCL config files


## Filters


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)

## Author

[Vladimir Botka](https://botka.link)

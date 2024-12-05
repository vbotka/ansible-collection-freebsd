# Ansible collection vbotka.freebsd

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)
[![Documentation Status](https://readthedocs.org/projects/ansible-collection-freebsd/badge/?version=latest)](https://ansible-collection-freebsd.readthedocs.io/en/latest/?badge=latest)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-collection-freebsd)](https://github.com/vbotka/ansible-collection-freebsd/tags)

[Ansible collection vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-collection-freebsd/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Documentation vbotka.freebsd

[ansible-collection-freebsd.readthedocs.io](https://ansible-collection-freebsd.readthedocs.io/en/stable/)


## Included content

The collection is shipped with

* module vbotka.freebsd.iocage
* inventory plugin vbotka.freebsd.iocage
* role vbotka.freebsd.iocage
* various playbooks


## Setup

See the directory *setup*. The admins can use the playbooks
*.configure.yml* and *setup.yml* to configure this collection and
setup plugins and roles.

### Plugins

The dictionary of plugins *bsd_plugins* is declared in the file
*setup/vars/plugins.yml*. Fit the entries to your needs and update the
dictionary *checksum* declared in the file *setup/vars/checksum.yml*.

Put the plugins you want to install into the dictionary
*bsd_plugins_install*, declared in the file
*setup/vars/plugins_install.yml*. Update the plugins

```sh
shell> ansible-playbook setup.yml -t plugins
```

This block of tasks:

* downloads the plugins into the directory *setup/distfiles* if not
  preinstalled
* patch the files if the attribute *patch* exists in *bsd_plugins*
* install the plugin

This procedure is not idempotent if a *patch* exists.

### Roles

TBD


## License

This collection is primarily licensed and distributed as a whole under

**BSD 2-Clause "Simplified" License**

SPDX-License-Identifier: [BSD-2-Clause](https://spdx.org/licenses/BSD-2-Clause.html)


## Author

[Vladimir Botka](https://botka.info)

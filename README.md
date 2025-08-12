# Ansible collection vbotka.freebsd

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)
[![Documentation Status](https://readthedocs.org/projects/ansible-collection-freebsd/badge/?version=latest)](https://ansible-collection-freebsd.readthedocs.io/en/latest/?badge=latest)
[![Codecov](https://img.shields.io/codecov/c/github/vbotka/ansible-collection-freebsd)](https://codecov.io/gh/vbotka/ansible-collection-freebsd)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-collection-freebsd)](https://github.com/vbotka/ansible-collection-freebsd/tags)

[Ansible collection vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-collection-freebsd/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Included content

This collection is shipped with

plugins:

* [module vbotka.freebsd.iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/) - iocage jail handling.
* [module vbotka.freebsd.service](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/) - control or list system services.
* [module vbotka.freebsd.ucl](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/) - CRUD-like interface for managing UCL files.
* [filter vbotka.freebsd.iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/) - parse iocage lists.
* [inventory vbotka.freebsd.iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/) - iocage inventory source.

roles:

* [role vbotka.freebsd.config_light](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light/) - install packages, configure files, services, and handlers.
* [role vbotka.freebsd.custom_image](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image/) - download, mount, and customize system images.
* [role vbotka.freebsd.iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/) - install and configure iocage.
* [role vbotka.freebsd.lib](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib/) - library of tasks.
* [role vbotka.freebsd.network](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/) - configure network.
* [role vbotka.freebsd.packages](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/) - configure repos and install packages.
* [role vbotka.freebsd.pf](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf/) - configure pf.
* [role vbotka.freebsd.postinstall](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/) - postinstall configuration.
* [role vbotka.freebsd.poudriere](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere/) - install and configure Poudriere build system.
* [role vbotka.freebsd.rsnapshot](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsnapshot/) - install and configure rsnapshot.
* [role vbotka.freebsd.zfs](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs/) - configure ZFS.

various [playbooks](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/?showing=playbook).


## Documentation

[ansible-collection-freebsd.readthedocs.io](https://ansible-collection-freebsd.readthedocs.io)


## Release Notes

See [changelog](https://github.com/vbotka/ansible-collection-freebsd/blob/master/changelogs/CHANGELOG.md).


## License

* This collection is primarily licensed and distributed as a whole under

  **BSD 2-Clause "Simplified" License**

  SPDX-License-Identifier: [BSD-2-Clause](https://spdx.org/licenses/BSD-2-Clause.html)

* The inventory plugin vbotka.freebsd.iocage is licensed and distributed as

  **GNU General Public License v3.0 or later**

  SPDX-License-Identifier: [GPL-3.0-or-later](https://spdx.org/licenses/GPL-3.0-or-later.html)


## Author

[Vladimir Botka](https://botka.info)

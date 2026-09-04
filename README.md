# Ansible collection vbotka.freebsd

[![Documentation Status](https://readthedocs.org/projects/ansible-collection-freebsd/badge/?version=latest)](https://ansible-collection-freebsd.readthedocs.io/en/latest/?badge=latest)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-collection-freebsd)](https://github.com/vbotka/ansible-collection-freebsd/tags)

[Ansible Galaxy](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd)|
[Documentation](https://ansible-collection-freebsd.readthedocs.io)|
[Release Notes](https://github.com/vbotka/ansible-collection-freebsd/blob/master/changelogs/CHANGELOG.md)


## Content

plugins:

* [module iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/) - iocage jail handling.
* [module service](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/) - Control or list system services.
* [module ucl](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/) - CRUD-like interface for managing UCL files.
* [inventory iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/) - iocage inventory source.
* [inventory iocage2](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/) - iocage inventory source (libzfs & iocage_lib).
* [filter ast_to_nginx](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/ast_to_nginx/) - Converts AST list to NGINX config.
* [filter dict_to_ast](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/dict_to_ast/) - Converts YAML dictionary to AST list.
* [filter from_ucl](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/from_ucl/) - Parses UCL string to YAML dictionary.
* [filter iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/) - Parses iocage lists.
* [filter to_ucl](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/to_ucl/) - Converts YAML dictionary to UCL string.
* [lookup galaxy_info](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/lookup/galaxy_info/) - Get galaxy.yml meta data.

roles:

* [apache](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/) - Install, configure, and run Apache HTTP server.
* [certificate](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate/) - Generate and/or check OpenSSL certificates.
* [config_light](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light/) - Install packages, configure files, services, and handlers.
* [custom_image](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image/) - Download, mount, and customize system images.
* [dhcp](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/dhcp/) - Install, configure, and run DHCP server.
* [iocage](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/) - Install and configure iocage.
* [iocage_template](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/) - Create iocage templates.
* [lib](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib/) - Library of tasks.
* [network](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/) - Configure network.
* [nginx](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/nginx/) - Install, configure, and run Nginx.
* [packages](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/) - Configure repos and install packages.
* [pf](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf/) - Configure pf.
* [postinstall](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/) - Postinstall configuration.
* [poudriere](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere/) - Install and configure Poudriere build system.
* [rsnapshot](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsnapshot/) - Install and configure rsnapshot.
* [zfs](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs/) - Configure ZFS.

various [playbooks](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/?showing=playbook).


## Copyright and License

This collection is primarily licensed and distributed as a whole under the **GNU
General Public License v3.0 or later** (GPL-3.0-or-later). Individual files or
components within this collection may be licensed under different licenses,
including the **BSD 2-Clause License** (BSD-2-Clause)

* Plugins running on the controller are licensed under the **GNU General Public License v3.0 or later** (`GPL-3.0-or-later`).
* Modules, roles, and playbooks are licensed under the **BSD 2-Clause License** (`BSD-2-Clause`).

See `LICENSES/GPL-3.0-or-later.txt` and `LICENSES/BSD-2-Clause.txt` for full license texts.


## Author

[Vladimir Botka](https://botka.info)

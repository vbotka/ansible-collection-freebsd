Plugins:

* `module iocage`_ - Manage iocage jails.
* `module service`_ - Control or query system services.
* `module ucl`_ - CRUD-like interface for managing UCL files.
* `inventory iocage`_ - iocage inventory source.
* `inventory iocage2`_ - iocage inventory source (using libzfs & iocage_lib).
* `filter ast_to_nginx`_ - Convert an AST list to an NGINX configuration.
* `filter dict_to_ast`_ - Convert a YAML dictionary to an AST list.
* `filter from_ucl`_ - Parse a UCL string to a YAML dictionary.
* `filter iocage`_ - Parse iocage output lists.
* `filter to_ucl`_ - Convert a YAML dictionary to a UCL string.
* `lookup galaxy_info`_ - Retrieve metadata from galaxy.yml.

Roles:

* `apache`_ - Install, configure, and manage the Apache HTTP server.
* `certificate`_ - Generate and verify OpenSSL certificates.
* `config_light`_ - Install packages and configure files, services, and handlers.
* `custom_image`_ - Download, mount, and customize system images.
* `dhcp`_ - Install, configure, and manage the DHCP server.
* `iocage`_ - Install and configure iocage.
* `iocage_template`_ - Create and configure iocage templates.
* `lib`_ - Task library providing reusable utilities.
* `network`_ - Configure system networking.
* `nginx`_ - Install, configure, and manage NGINX.
* `packages`_ - Configure package repositories and install packages.
* `pf`_ - Configure the Packet Filter (PF) firewall.
* `postinstall`_ - Perform post-installation system configuration.
* `poudriere`_ - Install and configure the Poudriere build system.
* `rsnapshot`_ - Install and configure rsnapshot backups.
* `zfs`_ - Configure ZFS storage pools and datasets.

Various :ref:`ug_playbooks`.


.. _module iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _module service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/
.. _module ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/

.. _inventory iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _inventory iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
.. _filter ast_to_nginx: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/ast_to_nginx/
.. _filter dict_to_ast: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/dict_to_ast/
.. _filter from_ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/from_ucl/
.. _filter iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/
.. _filter to_ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/to_ucl/
.. _lookup galaxy_info: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/lookup/galaxy_info/

.. _apache: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/
.. _certificate: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate/
.. _config_light: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light/
.. _custom_image: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image/
.. _dhcp: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/dhcp/
.. _iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _lib: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib/
.. _network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
.. _nginx: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/nginx/
.. _packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf/
.. _postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere/
.. _rsnapshot: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsnapshot/
.. _zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs/

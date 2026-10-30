Plugins:

* :ref:`module cgetent <ug_module_cgetent>` - Query capability database.
* :ref:`module iocage <ug_module_iocage>` - Manage iocage jails.
* :ref:`module service <ug_module_service>` - Control or query system services.
* :ref:`module ucl <ug_module_ucl>` - CRUD-like interface for managing UCL files.
* :ref:`inventory iocage <ug_inventory_iocage>` - iocage inventory source.
* :ref:`inventory iocage2 <ug_inventory_iocage2>` - iocage inventory source (using libzfs & iocage_lib).
* :ref:`filter ast_to_nginx <ug_filter_ast_to_nginx>` - Convert an AST list to an NGINX configuration.
* :ref:`filter ast_to_haproxy <ug_filter_ast_to_haproxy>` - Convert an AST dictionary to an HAProxy configuration.
* :ref:`filter clean_unsafe <ug_filter_clean_unsafe>` - Recursively remove __ansible_unsafe wrapper dictionaries.
* :ref:`filter from_ucl <ug_filter_from_ucl>` - Parse a UCL string to a YAML dictionary.
* :ref:`filter iocage <ug_filter_iocage>` - Parse iocage output lists.
* :ref:`filter to_ast <ug_filter_to_ast>` - Convert a YAML dictionary to an AST list.
* :ref:`filter to_ucl <ug_filter_to_ucl>` - Convert a YAML dictionary to a UCL string.
* :ref:`lookup galaxy_info <ug_lookup_galaxy_info>` - Retrieve metadata from galaxy.yml.

Roles:

* `apache <https://github.com/vbotka/ansible-apache>`__ - Install, configure, and run the `Apache HTTP server`_.
* `certificate <https://github.com/vbotka/ansible-certificate>`__ - Generate and verify `OpenSSL`_ certificates.
* `config_light <https://github.com/vbotka/ansible-config-light>`__ - Install packages and configure files, services, and handlers.
* `custom_image <https://github.com/vbotka/ansible-freebsd-custom-image>`__ - Download, mount, and customize system images.
* `dhcp <https://github.com/vbotka/ansible-freebsd-dhcp>`__ - Install, configure, and run the `DHCP`_ server.
* `haproxy <https://github.com/vbotka/ansible-freebsd-haproxy>`__ - Install, configure, and run the `HAProxy`_ load balancer.
* `iocage <https://github.com/vbotka/ansible-freebsd-iocage>`__ - Install and configure `iocage - FreeBSD Jail Manager`_.
* `iocage_template <https://github.com/vbotka/ansible-freebsd-iocage-template>`__ - Create and configure `iocage templates`_.
* `lib <https://github.com/vbotka/ansible-lib>`__ - Task library providing reusable utilities.
* `network <https://github.com/vbotka/ansible-freebsd-network>`__ - Configure system networking.
* `nginx <https://github.com/vbotka/ansible-freebsd-nginx>`__ - Install, configure, and run `NGINX`_.
* `packages <https://github.com/vbotka/ansible-freebsd-packages>`__ - Configure package repositories and install packages.
* `pf <https://github.com/vbotka/ansible-freebsd-pf>`__ - Configure the `Packet Filter (PF)`_ firewall.
* `postinstall <https://github.com/vbotka/ansible-freebsd-postinstall>`__ - Perform post-installation system configuration.
* `poudriere <https://github.com/vbotka/ansible-freebsd-poudriere>`__ - Install and configure the `Poudriere`_ build system.
* `rsnapshot <https://github.com/vbotka/ansible-rsnapshot>`__ - Install and configure `rsnapshot`_ backups.
* `zfs <https://github.com/vbotka/ansible-freebsd-zfs>`__ - Configure `ZFS`_ storage pools and datasets.

Various :ref:`ug_playbooks`.

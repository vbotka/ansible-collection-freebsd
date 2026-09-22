Plugins:

* :ref:`module iocage <ug_module_iocage>` - Manage iocage jails.
* :ref:`module service <ug_module_service>` - Control or query system services.
* :ref:`module ucl <ug_module_ucl>` - CRUD-like interface for managing UCL files.
* :ref:`inventory iocage <ug_inventory_iocage>` - iocage inventory source.
* :ref:`inventory iocage2 <ug_inventory_iocage2>` - iocage inventory source (using libzfs & iocage_lib).
* :ref:`filter ast_to_nginx <ug_filter_ast_to_nginx>` - Convert an AST list to an NGINX configuration.
* :ref:`filter to_ast <ug_filter_to_ast>` - Convert a YAML dictionary to an AST list.
* :ref:`filter from_ucl <ug_filter_from_ucl>` - Parse a UCL string to a YAML dictionary.
* :ref:`filter iocage <ug_filter_iocage>` - Parse iocage output lists.
* :ref:`filter to_ucl <ug_filter_to_ucl>` - Convert a YAML dictionary to a UCL string.
* :ref:`lookup galaxy_info <ug_lookup_galaxy_info>` - Retrieve metadata from galaxy.yml.

Roles:

* `apache`_ - Install, configure, and manage the Apache HTTP server.
* `certificate`_ - Generate and verify OpenSSL certificates.
* `config_light`_ - Install packages and configure files, services, and handlers.
* `custom_image`_ - Download, mount, and customize system images.
* `dhcp`_ - Install, configure, and manage the DHCP server.
* `iocage (role)`_ - Install and configure iocage.
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


Plugins:

* `module vbotka.freebsd.iocage`_ - iocage jail handling.
* `module vbotka.freebsd.service`_ - control or list system services.
* `module vbotka.freebsd.ucl`_ - CRUD-like interface for managing UCL files.
* `inventory vbotka.freebsd.iocage`_ - parse iocage lists.
* `filter vbotka.freebsd.iocage`_ - iocage inventory source.

Roles:

* `role vbotka.freebsd.config_light`_ - install packages, configure files, services, and handlers.
* `role vbotka.freebsd.custom_image`_ - download, mount, and customize system images.
* `role vbotka.freebsd.iocage`_ - install and configure iocage.
* `role vbotka.freebsd.network`_ - configure network.
* `role vbotka.freebsd.packages`_ - configure repos and install packages.
* `role vbotka.freebsd.pf`_ - configure pf.
* `role vbotka.freebsd.postinstall`_ - postinstall configuration.
* `role vbotka.freebsd.poudriere`_ - install and configure Poudriere build system.
* `role vbotka.freebsd.rsnapshot`_ - install and configure rsnapshot.

Various :ref:`ug_playbooks`.


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage
.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service
.. _module vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl

.. _inventory vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage

.. _role vbotka.freebsd.config_light: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light
.. _role vbotka.freebsd.custom_image: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/ccustom_image
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage
.. _role vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network
.. _role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages
.. _role vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf
.. _role vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _role vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere
.. _role vbotka.freebsd.rsnapshot: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsnapshot

.. _ug_introduction:

Introduction
************

* Supported systems: `FreeBSD Supported Production Releases`_

* Requirements:

  * `ansible.posix`_

  * `community.general`_

* The collection is shipped with:

  * `module vbotka.freebsd.iocage`_
  * `module vbotka.freebsd.service`_
  * `inventory plugin vbotka.freebsd.iocage`_
  * `filter vbotka.freebsd.iocage`_
  * `role vbotka.freebsd.iocage`_
  * `role vbotka.freebsd.packages`_
  * `role vbotka.freebsd.postinstall`_
  * various :ref:`ug_playbooks`

.. seealso::

   * `Managing BSD hosts with Ansible`_
   * `Jails and Containers - FreeBSD Handbook`_
   * `Jails - FreeBSD Wiki`_

.. hint::

   * Run Ansible in Python virtual environment. See `venv — Creation of virtual environments`_.
   * Use `result_format=yaml <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-result_format>`_
   * `Ansible claims`_:

      .. code-block:: text

	 BSD support is important to us at Ansible. ... we have an active BSD community
	 and strive to be as BSD-friendly as possible.

     Search `latest Ansible docs`_ for ``FreeBSD`` to learn the current FreeBSD support.


.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _FreeBSD Supported Production Releases: https://www.freebsd.org/releases
.. _ansible.posix: https://docs.ansible.com/ansible/latest/collections/ansible/posix
.. _community.general: https://docs.ansible.com/ansible/latest/collections/community/general
.. _Installing collections: https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html
.. _Managing BSD hosts with Ansible: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html
.. _Jails - FreeBSD Wiki: https://wiki.freebsd.org/Jails
.. _venv — Creation of virtual environments: https://docs.python.org/3/library/venv.html#module-venv
.. _community.general.yaml: https://docs.ansible.com/ansible/latest/collections/community/general/yaml_callback.html
.. _Ansible claims: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-efforts-and-contributions
.. _latest Ansible docs: https://docs.ansible.com/ansible/latest/
.. _Jails and Containers - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/jails/

.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/

.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _role vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/

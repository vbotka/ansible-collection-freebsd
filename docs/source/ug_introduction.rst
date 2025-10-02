.. _ug_introduction:

Introduction
************

.. index:: single: Managing BSD hosts with Ansible; Introduction
.. index:: single: result_format; Introduction
.. index:: single: venv — Creation of virtual environments; Introduction

* Supported systems: `FreeBSD Supported Production Releases`_
* Requirements:

  * `ansible.posix`_
  * `ansible.utils`_
  * `community.crypto`_
  * `community.general`_

The collection is shipped with:

.. include:: included_content.rst

.. note::

   * The above **Requirements** lists the collections required by the roles.
   * All listed collections are included in the standard `Ansible distribution`_.
   * The roles may require other roles not listed here. See the roles' ``requirements.yml`` files
     and install the missing roles manually when needed.

.. seealso::

   * `Managing BSD hosts with Ansible`_
   * `Jails and Containers - FreeBSD Handbook`_
   * `Jails - FreeBSD Wiki`_

.. hint::

   * Run Ansible in Python virtual environment. See `venv — Creation of virtual environments`_.
   * Use `result_format=yaml`_
   * `Ansible claims`_:

      .. code-block:: text

         BSD support is important to us at Ansible. ... we have an active BSD community
         and strive to be as BSD-friendly as possible.

     Search `latest Ansible docs`_ for ``FreeBSD`` to learn the current FreeBSD support.


.. _Ansible distribution: https://docs.ansible.com/ansible/latest/collections/index.html

.. _ansible.posix: https://docs.ansible.com/ansible/latest/collections/ansible/posix
.. _ansible.utils: https://docs.ansible.com/ansible/latest/collections/ansible/utils
.. _community.crypto: https://docs.ansible.com/ansible/latest/collections/community/crypto
.. _community.general: https://docs.ansible.com/ansible/latest/collections/community/general

.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _FreeBSD Supported Production Releases: https://www.freebsd.org/releases
.. _Installing collections: https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html
.. _Managing BSD hosts with Ansible: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html
.. _Jails - FreeBSD Wiki: https://wiki.freebsd.org/Jails
.. _venv — Creation of virtual environments: https://docs.python.org/3/library/venv.html#module-venv
.. _community.general.yaml: https://docs.ansible.com/ansible/latest/collections/community/general/yaml_callback.html
.. _Ansible claims: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#bsd-efforts-and-contributions
.. _latest Ansible docs: https://docs.ansible.com/ansible/latest/
.. _Jails and Containers - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/jails/
.. _result_format=yaml: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-result_format

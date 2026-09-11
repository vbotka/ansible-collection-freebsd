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

   * All collections listed in the above **Requirements** are included
     in the standard `Ansible distribution`_.

   * The roles may require other collections and/or roles not listed
     here. See the roles requirements.yml files and install the
     missing collections and/or roles manually when needed.

.. seealso::

   * `Managing BSD hosts with Ansible`_
   * `Jails and Containers - FreeBSD Handbook`_
   * `Jails - FreeBSD Wiki`_

.. tip::

   See the :ref:`ug_examples` and proof of concepts in the `Sandbox`_.

.. hint::

   * Run Ansible in Python virtual environment. See `venv — Creation
     of virtual environments`_.

   * Use `result_format=yaml`_

.. important::

   * `Ansible claims`_:

      .. code-block:: text

         BSD support is important to us at Ansible. ... we have an
         active BSD community and strive to be as BSD-friendly as
         possible.

     Search the `official Ansible documentation`_ for the current
     status of FreeBSD support.

pb_iocage_project_create_from_plugins
-------------------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: playbook pb_iocage_project_create_from_plugins.yml; pb_iocage_project_create_from_plugins
.. index:: single: project create from plugins; pb_iocage_project_create_from_plugins

Synopsis
^^^^^^^^

This playbook creates jails in a ``project``.

.. hint::

   Look at the ``Index`` and search ``playbook pb_iocage_project_create_from_plugins.yml``
   what examples are available.

Example
^^^^^^^

.. code-block:: yaml

   project:
     logserv:
       class: [logserv]
       plugin: syslog-ng
       vmm: iocage_05
     foo:
       class: [logclient]
       plugin: syslog-ng
       vmm: iocage_05
     bar:
       class: [logclient]
       plugin: syslog-ng
       vmm: iocage_05

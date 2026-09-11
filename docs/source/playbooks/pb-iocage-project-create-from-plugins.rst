pb_iocage_project_create_from_plugins
-------------------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: pb_iocage_project_create_from_plugins.yml; pb_iocage_project_create_from_plugins
.. index:: single: project create from plugins; pb_iocage_project_create_from_plugins

Synopsis
^^^^^^^^

This playbook creates jails in a project from plugins.

.. hint::

   Look at the ``Index`` and search the playbook
   ``pb_iocage_project_create_from_plugins.yml`` to see what examples
   are available.

Example
^^^^^^^

Define the project hosts and their assigned plugins in the ``project``
dictionary:

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

Execute the playbook:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_project_create_from_plugins.yml

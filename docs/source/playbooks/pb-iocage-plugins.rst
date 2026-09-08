pb_iocage_plugins
-----------------

.. contents::
   :local:
   :depth: 3

.. index:: single: pb_iocage_plugins.yml; pb_iocage_plugins

.. index:: single: tag enabled_plugins; pb_iocage_plugins
.. index:: single: tag project_plugins; pb_iocage_plugins
.. index:: single: tag swarm_plugins; pb_iocage_plugins

Synopsis
^^^^^^^^

This playbook fetches iocage plugins.

Examples
^^^^^^^^

enabled_plugins
"""""""""""""""

Define the list of plugins in ``enabled_plugins``:

.. code-block:: yaml

   enabled_plugins:
     - ansible-pull-syslogng-client
     - ansible-pull-syslogng-server

Use the playbook tag ``enabled_plugins`` to fetch the enabled iocage plugins:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_plugins.yml -t enabled_plugins

project_plugins
"""""""""""""""

Define the required plugins within the ``project`` dictionary:

.. code-block:: yaml

   project:
     logserv:
       class: [logserv]
       plugin: ansible-syslogng
       vmm: iocage_05
     foo:
       class: [logclient]
       plugin: ansible-syslogng
       vmm: iocage_05
     bar:
       class: [logclient]
       plugin: ansible-syslogng
       vmm: iocage_05

Use the playbook tag ``project_plugins`` to fetch plugins required by a project:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_plugins.yml -t project_plugins

swarm_plugins
"""""""""""""

Define the required plugins within the ``swarms`` dictionary:

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       plugin: ansible-zero

Use the playbook tag ``swarm_plugins`` to fetch plugins required by a swarm:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_plugins.yml -t swarm_plugins

plugins
"""""""

Declare plugin details, repositories, and properties in the ``plugins`` dictionary:

.. code-block:: yaml

   plugins:
     ansible-pull-syslogng-client:
       git: https://github.com/vbotka/iocage-plugins
       branch: main
       properties:
         bpf: 1
         dhcp: 1
         vnet: 1
     ansible-pull-syslogng-server:
       git: https://github.com/vbotka/iocage-plugins
       branch: main
       properties:
         bpf: 1
         dhcp: 1
         vnet: 1

.. hint::

   To find examples, search in the ``Index``:

   * pb_iocage_plugins.yml
   * tag enabled_plugins
   * tag project_plugins
   * tag swarm_plugins

.. seealso::

   * `man iocage <https://man.freebsd.org/cgi/man.cgi?iocage(8)>`_

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

This playbook fetches ``iocage plugins``.

Examples
^^^^^^^^

enabled_plugins
"""""""""""""""

Use the tag ``enabled_plugins`` to fetch the enabled iocage plugins. For example,

.. code-block:: yaml

   enabled_plugins:
     - ansible-pull-syslogng-client
     - ansible-pull-syslogng-server

project_plugins
"""""""""""""""

Use the tag ``project_plugins`` to fetch the iocage plugins required by a ``project``. For example,

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

swarm_plugins
"""""""""""""

Use the tag ``swarm_plugins`` to fetch the iocage plugins required by a ``swarm``. For example,

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       plugin: ansible-zero

plugins
"""""""

Declare the plugins in a dictionary. For example,

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

   To find the examples, search in the ``Index``:

   * pb_iocage_plugins.yml
   * tag enabled_plugins
   * tag project_plugins
   * tag swarm_plugins

.. seealso::

   * `man iocage`_


.. _man iocage: https://man.freebsd.org/cgi/man.cgi?iocage(8)

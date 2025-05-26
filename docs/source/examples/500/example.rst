.. _example_500:

500 Syslog server
-----------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: syslog server; Example 500

Use case
^^^^^^^^

Create and run a syslog server.

Tree
^^^^

::

  shell> tree .

Synopsis
^^^^^^^^

* At the iocage host *iocage_02*:
    
Requirements
^^^^^^^^^^^^

* root privilege on *iocage_02*

Notes
^^^^^

TBD

.. seealso::

   * TBD

.. note::

   * TBD

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/syslog_server/main.yml
   :language: yaml
   :caption: host_vars/syslog_server/main.yml

Playbook pb-syslog-server.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-syslog-server.yml
   :language: yaml

.. toctree::
   :caption: Playbook output
   :maxdepth: 1

   debug <pb_out_debug>
   
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall

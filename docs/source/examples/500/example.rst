.. _example_500:

500 Syslog server
-----------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: syslog server; Example 500

Use case
^^^^^^^^

Create and run a syslog server. Create syslog clients and test them.

Use the jails created in the project :ref:`example_207`. For example,

* Destroy all jails and templates. Run the play in :ref:`example_202`

  .. code-block:: console

     (env) > ansible-playbook -i iocage-hosts.ini vbotka.freebsd.pb_iocage_destroy_all_jails.yml

* Create *ansible_client* templates. Run the play in :ref:`example_202`

  .. code-block:: console

     (env) > ansible-playbook -i iocage-hosts.ini vbotka.freebsd.pb_iocage_template.yml

* Create jails. Run the play in :ref:`example_207`

  .. code-block:: console

     (env) > ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-create.yml

Tree
^^^^

TBD

Synopsis
^^^^^^^^

* At three iocage hosts:

  * iocage_01
  * iocage_02
  * iocage_03

TBD

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in the project :ref:`example_207`

Notes
^^^^^

TBD

.. seealso::

   * `Log Server Configuration`_
   * `syslog-ng`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^
   
.. literalinclude:: ansible.cfg
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/logserv/syslog.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/logclient/syslog.yml
   :language: yaml
   :caption:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/03_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml

Playbook output - display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Refresh cache.

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _Log Server Configuration: https://docs.freebsd.org/en/books/handbook/config/#_log_server_configuration
.. _syslog-ng: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

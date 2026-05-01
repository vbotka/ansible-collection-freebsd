.. _example_443:

443 Plugin ansible-zero
-----------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: swarms; Example 443

.. index:: single: playbook pb_iocage_ansible_clients.yml; Example 443
.. index:: single: playbook pb_iocage_plugins.yml; Example 443
.. index:: single: connection vbotka.freebsd.jailexec; Example 443
.. index:: single: inventory vbotka.freebsd.iocage; Example 443

.. index:: single: option compose; Example 443
.. index:: single: compose; Example 443

.. index:: single: variable iocage_tags; Example 443
.. index:: single: iocage_tags; Example 443

.. index:: single: option iocage --plugin-name; Example 443
.. index:: single: option iocage --git_repository; Example 443
.. index:: single: option iocage --count; Example 443
.. index:: single: option iocage --newmac; Example 443

.. index:: single: iocage plugins; Example 443
.. index:: single: iocage plugin ansible-zero; Example 443
.. index:: single: ansible-zero; Example 443

.. index:: single: ansible_jail_host; Example 443
.. index:: single: ansible_jail_name; Example 443
.. index:: single: ansible_jail_privilege_escalation; Example 443

Use case
^^^^^^^^

Clone multiple jails from the iocage plugin ``ansible-zero``. Use the `connection
plugin vbotka.freebsd.jailexec`_ to connect the jails.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   └── iocage_05.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* At a managed node:

  In the playbook `vbotka.freebsd.pb_iocage_plugins.yml`_:
  
  * Fetch the iocage plugin ``ansible-zero``

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_:
  
  * Clone jails from the iocage plugin ``ansible-zero``

* Create dynamic inventory to connect the jails by `connection plugin vbotka.freebsd.jailexec`_

* At all cloned jails:

  In the playbook ``pb-test.yml``:

  * Connect to the cloned jails
  * Display basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* iocage plugin ``ansible-zero``
* playbook `vbotka.freebsd.pb_iocage_plugins.yml`_
* playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_
* root privilege in the managed nodes

Notes
^^^^^

* The iocage plugin ``ansible-zero`` is used in the playbook
  `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ to create the ``swarm``.

.. seealso::

   * Example :ref:`example_050`
   * GitHub repository `iocage plugins`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05.yml
   :language: yaml
   :caption:
   :emphasize-lines: 6

.. note::

   By default, the jails cloned from the plugins inherit the iocage property type
   ``pluginv2``. Change it to ``jail``.

Playbook output - Fetch plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml \
                            -i iocage.ini \
                            -t swarm_plugins \
			    -e debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

.. note::

   The "Testing ansible-zero's DNSSEC response to pkg.FreeBSD.org" by ``iocage fetch`` may take some time.

Plugins at iocage_05
^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_05]# iocage list -P

.. literalinclude:: out/out-02.txt
   :language: bash

Playbook output - Create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage.ini \
                            -t swarm \
                            -e swarm=true \
                            -e debug=true

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Jails at iocage_05
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_05]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 9-12

.. note::

   iocage ``name`` doesn't work with ``ansible_jail_name``. iocage ``jid`` must be used
   instead.

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-05.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - Test jailexec connection plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

.. hint::

   The below play stops and destroys the jails in ``swarms`` ::

     ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                      -i iocage.ini \
                      -t swarm_destroy \
                      -e swarm_destroy=true


.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _vbotka.freebsd.pb_iocage_plugins.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_plugins.yml/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/ 
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/ 
.. _iocage plugins: https://github.com/vbotka/iocage-plugins/

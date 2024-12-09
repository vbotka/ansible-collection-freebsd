.. _example_001:

001 Debug variables and install iocage
--------------------------------------

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree
   .
   ├── ansible.cfg
   ├── host_vars
   │   ├── iocage_01
   │   │   └── iocage.yml
   │   └── iocage_02
   │       └── iocage.yml
   ├── iocage-hosts.ini
   └── pb-iocage.yml

Synopsis
^^^^^^^^

* On the iocage host *iocage_02*
  
  In the playbook *pb-iocage.yml*, use the role *vbotka.freebsd.iocage* to:

  * display variables
  * install iocage package.

Requirements
^^^^^^^^^^^^

* Role *vbotka.freebsd.iocage*
* root privilege on the *iocage* hosts

Notes
^^^^^

* Put `'-l iocage_01'` into the run-strings to run the play on the iocage host *iocage_01*
* Remove the limits `'-l iocage_0*'` to run the play on both iocage hosts.
* In this case, *debug* displays the role defaults.
* By default, *iocage* installation is enabled `'freebsd_iocage_install: true'`
* By default, *debug* is disabled `'freebsd_iocage_debug: false'` .

.. seealso::

   * `Patterns: targeting hosts and groups <https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html>`_

   * `Variable precedence: Where should I put a variable? <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_

Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

.. seealso::

   * `How to build your inventory <https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html>`_

   * `Connection methods and details <https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html>`_

   * `Understanding privilege escalation: become <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html>`_

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

.. seealso:: `Setting the Python interpreter <https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter>`_

Playbook *pb-iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
    :language: yaml

.. seealso:: `Ansible playbooks <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html>`_

Playbook output - display debug
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

.. seealso:: `ansible-playbook <https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html>`_

Playbook output - install iocage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-02.txt
    :language: bash

.. note:: This *debug* shows the *result* of already installed package.

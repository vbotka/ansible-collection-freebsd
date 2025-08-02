.. _example_001:

001 Install iocage
------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.iocage; Example 001
.. index:: single: iocage install; Example 001

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to install the package `iocage`_. Display debug variables.

Tree
^^^^

::

  shell> tree
  .
  ├── ansible.cfg
  ├── iocage.ini
  └── pb-iocage.yml

Synopsis
^^^^^^^^

* On the iocage host ``iocage_02``
  
  In the playbook ``pb-iocage.yml``, use the `role vbotka.freebsd.iocage`_ to:

  * display variables
  * install `iocage`_ package.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* root privilege on the iocage hosts.

Notes
^^^^^

* Put ``-l iocage_01`` into the run-strings to limit the play to the iocage host ``iocage_01``
* Remove the limits ``-l iocage_0*`` to run the play on both iocage hosts.
* By default, *iocage* installation is enabled ``freebsd_iocage_install: true``
* By default, *debug* is disabled ``freebsd_iocage_debug: false``

.. seealso::

   * `Patterns. Targeting hosts and groups.`_
   * `Variable precedence. Where should I put a variable?`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

.. seealso::

   * `How to build your inventory`_
   * `Connection methods and details`_
   * `Understanding privilege escalation`_
   * `Setting the Python interpreter`_

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml

.. seealso::

   `Ansible playbooks`_

Playbook output - display debug
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_02 \
                                          -t freebsd_iocage_debug \
                                          -e freebsd_iocage_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

.. seealso::

   * `ansible-playbook`_

Playbook output - install iocage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_02 \
                                          -t freebsd_iocage_pkg \
                                          -e freebsd_iocage_debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

.. note:: This ``debug`` shows the ``result`` of already installed package.


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _iocage: https://www.freshports.org/sysutils/iocage

.. _Patterns. Targeting hosts and groups.: https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html
.. _Variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
.. _How to build your inventory: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html
.. _Connection methods and details: https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html
.. _Understanding privilege escalation: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html
.. _Setting the Python interpreter: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter

.. _Ansible playbooks: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html
.. _ansible-playbook: https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html

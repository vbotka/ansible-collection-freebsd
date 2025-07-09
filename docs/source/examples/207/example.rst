.. _example_207:

207 Create DHCP jails from template v3. Auto UUID, iocage_tags, alias, class
----------------------------------------------------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: inventory vbotka.freebsd.iocage; Example 207
.. index:: single: inventory ansible.builtin.constructed; Example 207
.. index:: single: module ansible.builtin.command; Example 207
.. index:: single: template ansible_client; Example 207
.. index:: single: ansible_client; Example 207
.. index:: single: DHCP; Example 207
.. index:: single: alias; Example 207
.. index:: single: inventory alias; Example 207
.. index:: single: inventory class; Example 207
.. index:: single: option inventory_hostname_tag; Example 207
.. index:: single: inventory_hostname_tag; Example 207
.. index:: single: option get_properties; Example 207
.. index:: single: get_properties; Example 207
.. index:: single: option hooks_results; Example 207
.. index:: single: hooks_results; Example 207
.. index:: single: option compose; Example 207
.. index:: single: compose; Example 207
.. index:: single: option groups; Example 207
.. index:: single: option keyed_groups; Example 207
.. index:: single: property notes; Example 207
.. index:: single: notes; Example 207
.. index:: single: variable iocage_jails; Example 207
.. index:: single: iocage_jails; Example 207
.. index:: single: variable iocage_hooks; Example 207
.. index:: single: iocage_hooks; Example 207
.. index:: single: variable iocage_properties; Example 207
.. index:: single: iocage_properties; Example 207
.. index:: single: variable iocage_tags; Example 207
.. index:: single: iocage_tags; Example 207
.. index:: single: option iocage --count; Example 207
.. index:: single: option iocage --short; Example 207
.. index:: single: option iocage --template; Example 207

Use case
^^^^^^^^

At multiple iocage hosts, create and run VNET jails with a DHCP interface from the template
``ansible_client``. Use the dictionary ``iocage_tags`` and option ``inventory_hostname_tag`` to
create `inventory aliases`_. Group the jails by iocage hosts, states, and classes. Declare the
project in a single dictionary. The dictionary keys are jails aliases. For example,

.. code-block:: yaml

   project:
     logserv_1:
       class: [logserv]
       vmm: iocage_01
     http_1:
       class: [http, logclient]
       vmm: iocage_02
     db_1:
       class: [db, logclient]
       vmm: iocage_02
     http_2:
       class: [http, logclient]
       vmm: iocage_03
     db_2:
       class: [db, logclient]
       vmm: iocage_03

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project.yml
  ├── hosts
  │   ├── 01_iocage.yml
  │   ├── 02_iocage.yml
  │   ├── 03_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_03
  │       └── iocage.yml
  ├── iocage-hosts.ini
  ├── pb-iocage-project-create.yml
  ├── pb-iocage-project-destroy.yml
  └── pb-test-all.yml

Synopsis
^^^^^^^^

* At three iocage hosts:

  * iocage_01
  * iocage_02
  * iocage_03

  In the playbook *pb-iocage-project-create.yml*, use:

  * `inventory plugin vbotka.freebsd.iocage`_ to create inventory hosts
  * inventory plugin `ansible.builtin.constructed`_ to create groups and compose variables:

    * ``ansible_host``
    * ``iocage_tags``
    * ``iocage_classes``

  * module *ansible.builtin.command* and the `binary iocage`_ to:

    * create jails
    * set notes
    * start jails

* At all jails:

  In the playbook *pb-test-all.yml*, display:

  * variables:

    * ``ansible_host``
    * ``iocage_properties.host_hostuuid``
    * ``iocage_tags``
    * ``iocage_classes``

  * inventory groups.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* templates created in :ref:`example_202`

Notes
^^^^^

Templates created in :ref:`example_202` are used in this example.

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * `Binary iocage`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

List templates at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_01]# iocage list -lt

.. literalinclude:: out/out-01.txt
   :language: console

List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: console

List templates at iocage_03
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_03]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: console

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_03/iocage.yml
   :language: yaml
   :caption:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 9,10

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 9,10

.. literalinclude:: hosts/03_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 9,10

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

.. note::

   The following examples are tested with already present jails

   .. code-block:: console

      [iocage_01]# iocage list -h
      - test_1  down    13.5-RELEASE    -
      [iocage_02]# iocage list -h
      - test_2  down    14.2-RELEASE    -
      [iocage_03]# iocage list -h
      - test_3  down    14.2-RELEASE    -

Playbook pb-iocage-project-create.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-project-create.yml
   :language: yaml+jinja

.. note::

   The inventory ``-i hosts`` provides the group of all created jails. The play can use it and
   create only the missing project jails. This makes the play idempotent despite the used module
   *command* and *iocage* option ``--count``

Playbook output - create and start project jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-create.yml -e debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

.. note::

   * The inventory configuration files ``hosts/*.yml`` enable cache.
   * Flush the cache. Otherwise, the jails created in the previous play won't be included.

.. seealso::

   `ansible-playbook`_

Playbook output - display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-iocage-project-destroy.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Destroy the project if you don’t need it anymore.

.. literalinclude:: pb-iocage-project-destroy.yml
   :language: yaml

Playbook output - stop and destroy jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-destroy.yml -e debug=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook output - display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _Binary iocage: https://github.com/iocage/iocage
.. _binary iocage: https://github.com/iocage/iocage
.. _ansible-playbook: https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html
.. _inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _Inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _Set Jail Property: https://iocage.readthedocs.io/en/latest/basic-use.html?highlight=properties#set-jail-property

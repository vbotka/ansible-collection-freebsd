.. _example_207:

207 Create DHCP jails with auto UUID, iocage_tags, alias and class
------------------------------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible_client; Example 207
.. index:: single: ansible_client; Example 207
.. index:: single: DHCP; Example 207
.. index:: single: property notes; Example 207
.. index:: single: notes; Example 207

.. index:: single: alias; Example 207
.. index:: single: inventory alias; Example 207
.. index:: single: inventory class; Example 207

.. index:: single: filter vbotka.freebsd.project; Example 207
.. index:: single: vbotka.freebsd.project; Example 207
.. index:: single: project; Example 207

.. index:: single: inventory vbotka.freebsd.iocage; Example 207
.. index:: single: inventory ansible.builtin.constructed; Example 207
.. index:: single: module ansible.builtin.command; Example 207

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

.. index:: single: pb_iocage_project_create.yml; Example 207
.. index:: single: pb_iocage_project_destroy.yml; Example 207
.. index:: single: project create; Example 207
.. index:: single: project destroy; Example 207

Use case
^^^^^^^^

On multiple iocage hosts, create and run VNET jails with a DHCP
interface from the template ``ansible_client``. Use the dictionary
``iocage_tags`` and the option ``inventory_hostname_tag`` to create
`Inventory aliases`_. Group the jails by iocage hosts, states, and
classes. Declare the project in a single dictionary. The dictionary
keys are jail aliases. For example:

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
       vmm: iocage_04
     db_2:
       class: [db, logclient]
       vmm: iocage_04

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project.yml
  ├── hosts
  │   ├── 01_iocage.yml
  │   ├── 02_iocage.yml
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test-all.yml

Synopsis
^^^^^^^^

* On three managed nodes:

  * iocage_01
  * iocage_02
  * iocage_04

  In the playbook ``vbotka.freebsd.pb_iocage_project_create.yml``,
  use:

  * The :ref:`ug_inventory_iocage` to create inventory
    hosts

  * The inventory plugin `ansible.builtin.constructed`_ to create
    groups and compose variables:

    * ``ansible_host``
    * ``iocage_tags``
    * ``iocage_classes``

  * The module ``ansible.builtin.command`` and the `Binary iocage`_
    CLI to:

    * Create jails
    * Set notes
    * Start jails

* On all jails:

  In the playbook ``pb-test-all.yml``, display:

  * Variables:

    * ``ansible_host``
    * ``iocage_properties.host_hostuuid``
    * ``iocage_tags``
    * ``iocage_classes``

  * Inventory groups

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`
* Root privileges on the managed nodes
* Templates created in :ref:`example_202`

Notes
^^^^^

* Templates created in :ref:`example_202` are used in this example.

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * `Binary iocage`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Templates at iocage_01
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_01]# iocage list -lt

.. literalinclude:: out/out-01.txt
   :language: console

Templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: console

Templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: console

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 9,10

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 9,10

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 9,10

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

.. note::

   This example is tested with pre-existing jails:

   .. code-block:: console

      [iocage_01]# iocage list -h
      - test_1  down    13.5-RELEASE    -
      [iocage_02]# iocage list -h
      - test_2  down    14.2-RELEASE    -
      [iocage_04]# iocage list -h
      - test_4  down    14.3-RELEASE    -

Playbook output - Create and start project jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            -e debug=true \
			    vbotka.freebsd.pb_iocage_project_create.yml

.. seealso:: The playbook :ref:`ug_pb-iocage-project-create`

.. note::

   The inventory ``-i hosts`` provides the group of all existing
   jails, allowing the play to create only missing project jails. This
   makes the play idempotent despite using the module
   ``ansible.builtin.command`` with the ``iocage`` option ``--count``.

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

.. seealso::

   `ansible-playbook`_

Playbook output - Display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts --flush-cache pb-test-all.yml

.. note::

   * The inventory configuration files ``hosts/*.yml`` enable cache.

   * Flush the cache; otherwise, jails created in the previous play
     will not be included.

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook output - Stop and destroy jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            -e debug=true \
			    vbotka.freebsd.pb_iocage_project_destroy.yml

.. seealso:: The playbook :ref:`ug_pb-iocage-project-destroy`

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook output - Display remaining groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

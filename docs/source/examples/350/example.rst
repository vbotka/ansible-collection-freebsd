.. _example_350:

350 Role vbotka.freebsd.rsnapshot
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: rsnapshot; Example 350
   single: swarms; Example 350
   single: pb_iocage_ansible_clients.yml; Example 350
   single: role vbotka.freebsd.rsnapshot; Example 350
   single: vbotka.freebsd.rsnapshot; Example 350
   single: module community.general.pkgng; Example 350
   single: community.general.pkgng; Example 350

Use case
^^^^^^^^

Use the role `vbotka.freebsd.rsnapshot`_ to install and configure `rsnapshot`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── ansible-client.yml
  │       ├── common.yml
  │       └── rsnapshot.yml
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-install.yml
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-ansible-clients`, create and start jails.

  * In the playbook ``pb-install.yml``, install `rsnapshot`_ in the jails.

* On all created jails in the group ``swarm_sw_01``:

  * In the playbook ``pb.yml``, install and configure `rsnapshot`_.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-ansible-clients`
* Role `vbotka.freebsd.rsnapshot`_
* :ref:`ug_connection_jailexec`
* Template ``ansible-client`` created in :ref:`example_202`

Notes
^^^^^

* Jail names created by ``iocage`` do not work in the `jail
  parameter`_ of the module `community.general.pkgng`_. Use the JID
  instead::

    jail: "{{ iocage_jid }}"

* The plays run inside the jails. The inventory ``iocage.ini`` is
  needed when a task is delegated to an iocage host::

    delegate_to: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_::

    freebsd_pkgng_use_globs: false

  to specify packages in `pkg-origin`_ format::

    rsnapshot_packages:
      - sysutils/rsnapshot

.. note::

   | `vbotka.freebsd.rsnapshot`_ is the role **rsnapshot** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_rsnapshot`_ is the role **freebsd_rsnapshot** in the namespace `vbotka`_.

.. seealso::

   * :ref:`ug_qa_jexec_iocage_name`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/rsnapshot.yml
   :language: yaml+jinja
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            -e iocage_jails_source=inventory \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts -i iocage.ini --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-install.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-install.yml
   :language: yaml+jinja

Playbook output - Install rsnapshot
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed when a task is delegated to an iocage
host:

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-install.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts \
                            -t rsnapshot_debug -e rsnapshot_debug=true \
                            pb.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook output - Configure rsnapshot
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Results
^^^^^^^

* TBD.
.. _example_524:

524 iocage template ansible-init
--------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: ansible_init; Example 524
   single: service ansible_init; Example 524
   single: template ansible-init; Example 524
   single: firstboot; Example 524
   single: ansible-conf-init; Example 524
   single: ansible-conf-test; Example 524
   single: repo ansible-conf-init; Example 524
   single: repo ansible-conf-test; Example 524
   single: ansible-pull; Example 524
   single: role vbotka.freebsd.iocage_template; Example 524
   single: filter vbotka.freebsd.project; Example 524
   single: vbotka.freebsd.project; Example 524
   single: project; Example 524
   single: connection vbotka.freebsd.jailexec; Example 524
   single: vbotka.freebsd.jailexec; Example 524
   single: jailexec; Example 524
   single: inventory vbotka.freebsd.iocage2; Example 524
   single: ansible_init_enable; Example 524
   single: ansible_init_host; Example 524
   single: ansible_init_repo; Example 524
   single: ansible_init_playbook; Example 524

Use case
^^^^^^^^

* Create `iocage template`_ ``ansible-init`` using the role
  `vbotka.freebsd.iocage_template`_. Enable the `firstboot`_ service
  `ansible_init`_ that runs `ansible-pull`_ from the repository
  `ansible-conf-init`_ (default) on ``project_hosts.repos``.

* Configure dictionaries ``ai_db_*`` in `ansible-conf-init`_ to pull
  configuration for the jails *foo* and *bar* from the repository
  `ansible-conf-test`_, and to run `ansible-pull`_ asynchronously.


* Create jails from the template using the playbook
  :ref:`ug_pb-iocage-project-create-from-templates`.

See the concepts:

* :ref:`ug_concepts_ansible_init`
* :ref:`ug_concepts_ansible_conf_init`

.. hint::

   Use the template ``ansible-init`` created in the example :ref:`example_529`
   if you created the package repositories in the example
   :ref:`example_322`. The installation of the packages in the jails will be
   more efficient.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── ansible-init.sh
  │   └── pkgs.json
  ├── group_vars
  │   └── iocage
  │       ├── project-hosts.yml
  │       └── project.yml
  │       └── template.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── template.yml
  │   └── iocage_06
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  └── templates
      └── project-hosts.yml.j2

Synopsis
^^^^^^^^

* On the managed nodes:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the template
    ``ansible-init``.

  * In the playbook :ref:`ug_pb-iocage-project-create-from-templates`, create
    jails from the template ``ansible-init``.

  * Wait for `ansible-pull`_ to configure the jails and display the test files.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.iocage_template`_
* Playbook :ref:`ug_pb-iocage-project-create-from-templates`
* :ref:`ug_filter_project`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Jail ``repos`` created in the example :ref:`example_523`.

Notes
^^^^^

* See `Practical rc.d scripting in BSD`_.
* See the option ``firstboot_sentinel`` in `man rc.conf`_.

.. note::

   | `vbotka.freebsd.iocage_template`_ is the role **iocage_template** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_iocage_template`_ is the role **freebsd_iocage_template** in the namespace `vbotka`_.

.. seealso::

   * The ``Troubleshooting`` section in :ref:`example_526`
   * GitHub repositories:

     * `ansible-conf-init`_
     * `ansible-conf-test`_

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

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/iocage/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/template.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/template.yml
   :language: yaml+jinja
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/project-hosts.yml.j2
   :language: jinja
   :caption:

files
^^^^^

.. literalinclude:: files/ansible-init.sh
   :language: sh
   :caption:

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja

Playbook output - Create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Templates
^^^^^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_05]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -lt

Playbook output - Create jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-05.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-06.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-07.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Display the test files
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-08.txt
   :language: text
   :caption: [iocage_05]# iocage exec foo "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-09.txt
   :language: text
   :caption: [iocage_06]# iocage exec bar "cat /tmp/ansible-hello-world.txt"

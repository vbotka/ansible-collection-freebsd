.. _example_525:

525 iocage template ansible-init (class)
----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: ansible_init; Example 525
   single: service ansible_init; Example 525
   single: template ansible-init; Example 525
   single: firstboot; Example 525
   single: ansible-conf-init; Example 525
   single: ansible-conf-test; Example 525
   single: repo ansible-conf-init; Example 525
   single: repo ansible-conf-test; Example 525
   single: ansible-pull; Example 525
   single: pb_iocage_project_create_from_templates.yml; Example 525
   single: filter vbotka.freebsd.project; Example 525
   single: vbotka.freebsd.project; Example 525
   single: project; Example 525
   single: connection vbotka.freebsd.jailexec; Example 525
   single: vbotka.freebsd.jailexec; Example 525
   single: jailexec; Example 525
   single: inventory vbotka.freebsd.iocage2; Example 525

Use case
^^^^^^^^

* Use the `iocage template`_ ``ansible-init`` created in :ref:`example_524` or
  :ref:`example_529`.

* Configure dictionaries ``ai_db_*`` in `ansible-conf-init`_ to pull
  configuration for the jails in ``call=test`` from the repository
  `ansible-conf-test`_, and to run `ansible-pull`_ asynchronously.

* In the project host definitions configure the jails ``class=test``.

* Create jails from the template using the playbook
  :ref:`ug_pb-iocage-project-create-from-templates`.

See the concepts:

* :ref:`ug_concepts_ansible_init`
* :ref:`ug_concepts_ansible_conf_init`
* :ref:`ug_concepts_iocage_class`

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── iocage
  │       ├── project-hosts.yml
  │       └── project.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  └── templates
      └── project-hosts.yml.j2

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-project-create-from-templates`, create
    jails from the template ``ansible-init``.

  * Wait for `ansible-pull`_ to configure the jails and display the test files.

.. note::

   The only difference compared to :ref:`example_524` is the dictionary used for
   the jails' configuration. In this example, the jails (baz and qux) are **not
   included** in the ``ai_db_host`` dictionary; instead, they are configured from
   the ``ai_db_class`` dictionary. See the `ansible-conf-init`_ repository.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-project-create-from-templates`
* :ref:`ug_filter_project`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Jail ``repos`` created in the example :ref:`example_523`.
* Template ``ansible-init`` created in:

  * :ref:`example_529`, or
  * :ref:`example_524`.

.. note::

   * See `Practical rc.d scripting in BSD`_.
   * See the option ``firstboot_sentinel`` in `man rc.conf`_.

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

templates
^^^^^^^^^

.. literalinclude:: templates/project-hosts.yml.j2
   :language: jinja
   :caption:

Playbook output - Create jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Display the test files
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-05.txt
   :language: text
   :caption: [iocage_05]# iocage exec baz "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-06.txt
   :language: text
   :caption: [iocage_06]# iocage exec qux "cat /tmp/ansible-hello-world.txt"

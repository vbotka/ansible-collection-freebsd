.. _example_525:

525 iocage template ansible-init (class)
----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_init; Example 525
.. index:: single: service ansible_init; Example 525
.. index:: single: template ansible-init; Example 525
.. index:: single: firstboot; Example 525
.. index:: single: ansible-conf-init; Example 525
.. index:: single: ansible-conf-test; Example 525
.. index:: single: repo ansible-conf-init; Example 525
.. index:: single: repo ansible-conf-test; Example 525
.. index:: single: ansible-pull; Example 525
.. index:: single: pb_iocage_project_create_from_templates.yml; Example 525

.. index:: single: filter vbotka.freebsd.project; Example 525
.. index:: single: vbotka.freebsd.project; Example 525
.. index:: single: project; Example 525

.. index:: single: connection vbotka.freebsd.jailexec; Example 525
.. index:: single: vbotka.freebsd.jailexec; Example 525
.. index:: single: jailexec; Example 525

.. index:: single: inventory vbotka.freebsd.iocage2; Example 525

Use case
^^^^^^^^

Use the `iocage`_ template ``ansible-init`` created in
:ref:`example_524`. Configure the repo `ansible-conf-init`_ to pull
the jails' configuration from the repo `ansible-conf-test`_. Create
jails from the template. Use ``class=test`` to select the
configuration. Run `ansible-pull`_ asynchronously.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── project-hosts.yml
  │       └── project.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── iocage.ini
  └── templates
      └── project-hosts.yml.j2

Synopsis
^^^^^^^^

* On a managed node:

  * In the playbook
    `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_,
    create jails from the template ``ansible-init``.

  * Wait for `ansible-pull`_ to configure the jails and display the
    test files.

.. note::

   The only difference compared to :ref:`example_524` is the
   dictionary used for the jails' configuration. In this example, the
   jails (baz and qux) are not included in the ``ai_db_host``
   dictionary; instead, they are configured from the ``ai_db_class``
   dictionary. See the `ansible-conf-init`_ repository.

Requirements
^^^^^^^^^^^^

* Jail ``repos`` created in :ref:`example_523`.
* Template ``ansible-init`` created in :ref:`example_524`.
* Playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_.
* `Filter vbotka.freebsd.project`_.
* `Inventory vbotka.freebsd.iocage2`_.
* :ref:`ug_connection_jailexec`.

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

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/project-hosts.yml.j2
   :language: jinja
   :caption:

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-05.txt
   :language: sh

Display the test files
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage exec baz "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-06.txt
   :language: sh

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage exec qux "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-07.txt
   :language: sh

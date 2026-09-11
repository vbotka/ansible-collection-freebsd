.. _example_524:

524 iocage template ansible-init
--------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_init; Example 524
.. index:: single: service ansible_init; Example 524
.. index:: single: template ansible-init; Example 524
.. index:: single: firstboot; Example 524
.. index:: single: ansible-conf-init; Example 524
.. index:: single: ansible-conf-test; Example 524
.. index:: single: repo ansible-conf-init; Example 524
.. index:: single: repo ansible-conf-test; Example 524
.. index:: single: ansible-pull; Example 524
.. index:: single: role vbotka.freebsd.iocage_template; Example 524

.. index:: single: filter vbotka.freebsd.project; Example 524
.. index:: single: vbotka.freebsd.project; Example 524
.. index:: single: project; Example 524

.. index:: single: connection vbotka.freebsd.jailexec; Example 524
.. index:: single: vbotka.freebsd.jailexec; Example 524
.. index:: single: jailexec; Example 524

.. index:: single: inventory vbotka.freebsd.iocage2; Example 524

Use case
^^^^^^^^

Create the `iocage`_ template ``ansible-init``. Configure a
``firstboot`` service ``ansible_init`` that runs `ansible-pull`_ and
uses the repo `ansible-conf-init`_. Configure the repo
`ansible-conf-init`_ to pull the jails' configuration from the repo
`ansible-conf-test`_. Create jails from the template. Use the
``hostname`` to select the configuration. Run `ansible-pull`_
asynchronously.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pkgs-15_0.json
  │   └── pkgs-15_1.json
  ├── group_vars
  │   └── all
  │       ├── project-hosts.yml
  │       └── project.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── host_vars
  │   └── iocage_06
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  └── templates
      └── project-hosts.yml.j2

Synopsis
^^^^^^^^

* On a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the
    template ``ansible-init``.

  * In the playbook
    `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_,
    create jails from the template.

  * Wait for `ansible-pull`_ to configure the jails and display the
    test files.

Requirements
^^^^^^^^^^^^

* Jail ``repos`` created in :ref:`example_523`.
* Role `vbotka.freebsd.iocage_template`_.
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

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

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

.. literalinclude:: files/pkgs-15_1.json
   :language: json
   :caption:

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja

Playbook output - Create iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: sh

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

   shell> ssh admin@iocage_06 sudo iocage exec foo "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-06.txt
   :language: sh

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage exec bar "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-07.txt
   :language: sh

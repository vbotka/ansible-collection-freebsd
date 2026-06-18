.. _example_525:

525 iocage template ansible_init (class)
----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_init; Example 525
.. index:: single: service ansible_init; Example 525
.. index:: single: template ansible_init; Example 525
.. index:: single: firstboot; Example 525
.. index:: single: ansible-conf-init; Example 525
.. index:: single: ansible-conf-test; Example 525
.. index:: single: repo ansible-conf-init; Example 525
.. index:: single: repo ansible-conf-test; Example 525
.. index:: single: ansible-pull; Example 525
.. index:: single: pb_iocage_project_create_from_templates.yml; Example 525
.. index:: single: connection vbotka.freebsd.jailexec; Example 525
.. index:: single: inventory vbotka.freebsd.iocage; Example 525

Use case
^^^^^^^^

Use the `iocage`_ template ``ansible_init`` created in :ref:`example_524`. Configure the repo
`ansible-conf-init`_ to pull the jails' configuration from the repo `ansible-conf-test`_. Create
jails from the template. Use ``class=test`` to select the configuration. Run `ansible-pull`_
asynchronously.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project.yml
  ├── hosts
  │   └── 05_iocage.yml
  └── iocage.ini

Synopsis
^^^^^^^^

* At a managed node:

  * In the playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails from
    the template ``ansible_init``.

  * Wait for ``ansible-pull`` to configure the jails and display the test files.

.. note::

   The only difference compared to :ref:`example_524` is the dictionary used for the jails'
   configuration. In this example, the jails (baz and qux) are not included in the ``ai_db_host``
   dictionary; instead, they are configured from the ``ai_db_class`` dictionary. See the repository
   `ansible-conf-init`_.

Requirements
^^^^^^^^^^^^

* template ``ansible_init`` created in :ref:`example_524`
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_

.. note::

   * See `Practical rc.d scripting in BSD`_
   * See the option ``firstboot_sentinel`` in `man rc.conf`_
   * See the example :ref:`example_523`
   * See the section ``Troubleshooting`` in :ref:`example_526`

.. seealso::

   GitHub repositories:

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

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml
   :caption:

group_vars
^^^^^^^^^^
.. literalinclude:: group_vars/all/project.yml
   :language: yaml
   :caption:

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -l

.. literalinclude:: out/out-04.txt
   :language: sh

Display the test files
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage exec baz "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-05.txt
   :language: sh

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage exec qux "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-06.txt
   :language: sh


.. _Practical rc.d scripting in BSD: https://docs.freebsd.org/en/articles/rc-scripting/
.. _man rc.conf: https://man.freebsd.org/cgi/man.cgi?rc.conf

.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/

.. _ansible-pull: https://docs.ansible.com/projects/ansible/latest/cli/ansible-pull.html
.. _git-daemon: https://man.freebsd.org/cgi/man.cgi?query=git-daemon
.. _base-path: https://git-scm.com/docs/git-daemon#Documentation/git-daemon.txt---base-pathpath
.. _iocage: https://iocage.readthedocs.io/en/latest/

.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init
.. _ansible-conf-test: https://github.com/vbotka/ansible-conf-test

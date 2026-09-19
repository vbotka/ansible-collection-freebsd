.. _example_529:

529 iocage template ansible-init (local repo)
---------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: local pkg repo; Example 529
.. index:: single: pkg repo; Example 529
.. index:: single: ansible_init; Example 529
.. index:: single: service ansible_init; Example 529
.. index:: single: template ansible-init; Example 529
.. index:: single: firstboot; Example 529
.. index:: single: ansible-pull; Example 529
.. index:: single: role vbotka.freebsd.iocage_template; Example 529

Use case
^^^^^^^^

Create the `iocage`_ template ``ansible-init``. Enable the `firstboot`_ service
`ansible_init`_ that runs `ansible-pull`_ from the repositories on
``project_hosts.repos``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── ansible-init.sh
  ├── group_vars
  │   └── all
  │       ├── project-hosts.yml
  │       └── template.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── local-pkg-conf.yml
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  └── templates
      └── local.conf.j2

Synopsis
^^^^^^^^

* On a managed node, use the role `vbotka.freebsd.iocage_template`_ to create
  the template ``ansible-init``.

Requirements
^^^^^^^^^^^^

* Package repository created in :ref:`example_322`
* Role `vbotka.freebsd.iocage_template`_

Notes
^^^^^

* TBD

.. note::

   | `vbotka.freebsd.iocage_template`_ is the role **iocage_template** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_iocage_template`_ is the role **freebsd_iocage_template** in the namespace `vbotka`_.

.. seealso::

   * GitHub repository `ansible-conf-init`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/template.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/local-pkg-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/template.yml
   :language: yaml+jinja
   :caption:

files
^^^^^

.. literalinclude:: files/ansible-init.sh
   :language: bash
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/local.conf.j2
   :language: jinja
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

Templates
^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash
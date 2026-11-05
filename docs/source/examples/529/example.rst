.. _example_529:

529 iocage template ansible-init (local repo)
---------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: local pkg repo; Example 529
   single: pkg repo; Example 529
   single: ansible_init; Example 529
   single: service ansible_init; Example 529
   single: template ansible-init; Example 529
   single: firstboot; Example 529
   single: ansible-pull; Example 529
   single: role vbotka.freebsd.iocage_template; Example 529

Use case
^^^^^^^^

Create the `iocage template`_ ``ansible-init`` using the role
`vbotka.freebsd.iocage_template`_. Enable the `firstboot`_ service
`ansible_init`_ that runs `ansible-pull`_ from the repository
`ansible-conf-init`_ (default) on ``project_hosts.repos``. Configure the the
template to install packages from the ``local`` repository on
``project_hosts.default_pkg_repo``.

See the concepts:

* :ref:`ug_concepts_ansible_init`
* :ref:`ug_concepts_ansible_conf_init`

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── ansible-init.sh
  ├── group_vars
  │   └── iocage
  │       ├── local-pkg-conf.yml
  │       ├── project-hosts.yml
  │       ├── template-common.yml
  │       └── template.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── release.yml
  │   └── iocage_06
  │       └── release.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  └── templates
      └── local.conf.j2

Synopsis
^^^^^^^^

* On the managed nodes:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the template
    ``ansible-init``.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.iocage_template`_
* Package repository created in the example :ref:`example_322`.

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

.. literalinclude:: group_vars/iocage/local-pkg-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/template-common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/template.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/release.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/release.yml
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

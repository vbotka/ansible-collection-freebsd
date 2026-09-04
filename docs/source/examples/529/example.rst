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

Create `iocage`_ template ``ansible-init``. Enable ``firstboot`` service
``ansible_init`` that runs `ansible-pull`_ from the repositories on
``project_hosts.repos``.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── ansible-init.sh
  ├── group_vars
  │   └── all
  │       ├── project-hosts.yml
  │       └── template.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── local-pkg-conf.yml
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  └── templates
      └── local.conf.j2

Synopsis
^^^^^^^^

* At a managed node, use the role `vbotka.freebsd.iocage_template`_ to create
  the template ``ansible-init``

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* package repository created in :ref:`example_322`

.. note::

   TBD

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
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/template.yml
   :language: yaml
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
   :language: sh
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
   :language: yaml
   :force:
      
List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_06 sudo iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: sh


.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _ansible-pull: https://docs.ansible.com/projects/ansible/latest/cli/ansible-pull.html
.. _iocage: https://iocage.readthedocs.io/en/latest/
.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init

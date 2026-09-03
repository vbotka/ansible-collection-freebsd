.. _example_530:

530 Create all templates in one play
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: local pkg repo; Example 530
.. index:: single: template ansible-pkg-repos; Example 530
.. index:: single: template ansible-repos; Example 530
.. index:: single: template ansible-init; Example 530
.. index:: single: template ansible-nginx; Example 530

Use case
^^^^^^^^

Create `iocage`_ templates in one play.

Tree
^^^^

::

  shell> tree .
  ├── ansible.cfg
  ├── conf.d
  │   ├── 435
  │   │   └── template.yml
  │   ├── 523
  │   │   └── template.yml
  │   ├── 527
  │   │   └── template.yml
  │   └── 529
  │       └── template.yml
  ├── files
  │   ├── ansible-init.sh
  │   └── index.html
  ├── group_vars
  │   └── all
  │       ├── project-hosts.yml
  │       └── template.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── local-pkg-conf.yml
  │       └── nginx-pkg-repo.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  ├── tasks
  │   └── create_template.yml
  └── templates
      ├── local.conf.j2
      └── nginx-pkg-repo.conf.j2

Synopsis
^^^^^^^^

* At a managed node use the role `vbotka.freebsd.iocage_template`_ to create the
  templates:

  - ansible-init
  - ansible-nginx
  - ansible-pkg-repo
  - ansible-repos

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_

Notes
^^^^^

* TBD

.. seealso::

   * TBD

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

conf.d
^^^^^^

.. literalinclude:: conf.d/435/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf.d/523/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf.d/527/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf.d/529/template.yml
   :language: yaml+jinja
   :caption:

files
^^^^^

.. literalinclude:: files/ansible-init.sh
   :language: sh
   :caption:

.. literalinclude:: files/index.html
   :language: html
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/local-pkg-conf.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_06/nginx-pkg-repo.yml
   :language: yaml
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/local.conf.j2
   :language: jinja
   :caption:

.. literalinclude:: templates/nginx-pkg-repo.conf.j2
   :language: jinja
   :caption:

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: tasks/create_template.yml
   :language: yaml+jinja
   :caption:

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


.. _iocage: https://iocage.readthedocs.io/en/latest/ 
.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/

.. _example_410:

410 Include variables from conf.d
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: al_include_confd_vars_list; Example 410
.. index:: single: role vbotka.freebsd.lib; Example 410
.. index:: single: vbotka.freebsd.lib; Example 410

Use case
^^^^^^^^

Create list of variables from files in the directory ``conf.d``. Use the role `vbotka.freebsd.lib`_
tasks `al_include_confd_vars_list.yml`_

.. code-block:: yaml

   - name: Create list of vars from files in directory conf.d
     vars:
       al_include_confd_dir: "{{ playbook_dir }}/conf.d"
     ansible.builtin.import_role:
       name: vbotka.freebsd.lib
       tasks_from: al_include_confd_vars_list

Tree
^^^^

::

  shell > tree .
  .
  ├── ansible.cfg
  ├── conf.d
  │   ├── devel.yml
  │   ├── production.yml
  │   └── qa.yml
  ├── hosts
  └── pb.yml

Synopsis
^^^^^^^^

* At the managed node:

  * Create a list of variables' values from files in the controller's directory ``conf.d``
  * Display the created list.
  
Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.lib`_

Notes
^^^^^

The variables' names are not collected. The resulting list comprises the variables' values only.

.. note::

   | `vbotka.freebsd.lib`_ is the role **lib** in the collection `vbotka.freebsd`_
   | `vbotka.ansible_lib`_ is the role **ansible_lib** in the namespace `vbotka`_
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `al_include_confd_vars_list.yml`_
   * `Special variable playbook_dir`_

ansible.cfg
^^^^^^^^^^^
   
.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^
   
.. literalinclude:: hosts
   :language: ini

conf.d
^^^^^^

.. literalinclude:: conf.d/devel.yml
   :language: yaml
   :caption:

.. literalinclude:: conf.d/production.yml
   :language: yaml
   :caption:

.. literalinclude:: conf.d/qa.yml
   :language: yaml
   :caption:

Expected results
^^^^^^^^^^^^^^^^

.. code-block:: yaml

   al_include_confd_vars_list_type: plain
   al_include_confd_vars_list:
     - team: production
       users: [alice, bob]
     - team: qa1
       users: [mallory, ted]
     - team: qa2
       users: [darth, wendy]
     - team: devel
       users: [charlie, david]


.. code-block:: yaml

   al_include_confd_vars_list_type: fname
   al_include_confd_vars_list:
     - fname: production
       vars:
         - team: production
           users: [alice, bob]
     - fname: qa
       vars:
         - team: qa1
           users: [mallory, ted]
         - team: qa2
           users: [darth, wendy]
     - fname: devel
       vars:
         - team: devel
           users: [charlie, david]

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :emphasize-lines: 44-53, 105-120
   :force:


.. _vbotka.freebsd.lib: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib/
.. _vbotka.ansible_lib: https://galaxy.ansible.com/ui/standalone/roles/vbotka/ansible_lib/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _al_include_confd_vars_list.yml: https://github.com/vbotka/ansible-lib/blob/master/tasks/al_include_confd_vars_list.yml

.. _Special variable playbook_dir: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-playbook_dir

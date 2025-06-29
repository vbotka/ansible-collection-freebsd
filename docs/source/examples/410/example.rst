.. _example_410:

410 Include variables from conf.d
---------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: al_include_confd_vars_list; Example 410
.. index:: single: role vbotka.freebsd.lib; Example 410
.. index:: single: vbotka.freebsd.lib; Example 410

Use case
^^^^^^^^

Create list of variables from files in the directory ``conf.d``. Use the role
`vbotka.freebsd.lib`_ tasks ``al_include_confd_vars_list.yml``

.. code-block:: yaml

   - name: Create list of vars from files in directory conf.d
     vars:
       al_include_dir_vars_dir: "{{ playbook_dir }}/conf.d"
     include_role:
       name: vbotka.ansible_lib
       tasks_from: al_include_confd_vars_list.yml

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
  ├── hosts.ini
  └── pb-include_confd_vars_list.yml

Synopsis
^^^^^^^^

* At all hosts:

  * Create a list of variables values from files in the controller's directory conf.d
  * Display the created list.
  
Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.lib`_

Notes
^^^^^

The variables' names are not collected. The resulting list comprises the variables' values only.

.. note::

   | `vbotka.freebsd.lib`_ is the role **lib** in the collection `vbotka.freebsd`_.
   | `vbotka.ansible_lib`_ is the role **ansible_lib** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `Special variable playbook_dir`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^
   
.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts.ini
^^^^^^^^^^^^^^^^^^^
   
.. literalinclude:: hosts.ini
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

Playbook pb-include_confd_vars_list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-include_confd_vars_list.yml
   :language: yaml

Playbook output - debug display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-include_confd_vars_list.yml -i hosts.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :emphasize-lines: 47-56, 111-126
   :force:


.. _vbotka.freebsd.lib: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib
.. _vbotka.ansible_lib: https://galaxy.ansible.com/ui/standalone/roles/vbotka/ansible_lib
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289

.. _Special variable playbook_dir: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-playbook_dir

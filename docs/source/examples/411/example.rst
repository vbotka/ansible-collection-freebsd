.. _example_411:

411 Include variables from nested directories
---------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: al_include_dir_vars; Example 411
.. index:: single: role vbotka.freebsd.lib; Example 411
.. index:: single: vbotka.freebsd.lib; Example 411

Use case
^^^^^^^^

Create a dictionary of variables from nested directories in ``al_vars``. Use the role
`vbotka.freebsd.lib`_ tasks `al_include_dir_vars.yml`_

.. code-block:: yaml

   - name: Create dict of vars from nested directories in al_vars
     vars:
       al_include_dir_vars_dir: "{{ playbook_dir }}/al_vars"
     include_role:
       name: vbotka.freebsd.lib
       tasks_from: al_include_dir_vars

Tree
^^^^

::

  shell > tree .
  .
  ├── al_vars
  │   └── team
  │       ├── devel
  │       ├── production
  │       └── qa
  ├── ansible.cfg
  ├── example.rst
  ├── hosts
  ├── out
  │   └── out-01.txt
  └── pb.yml

Synopsis
^^^^^^^^

* At the managed node:

  * Create a dictionary of variables from nested directories in the controller's directory ``al_vars``
  * Display the created dictionary.
  
Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.lib`_

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.lib`_ is the role **lib** in the collection `vbotka.freebsd`_
   | `vbotka.ansible_lib`_ is the role **ansible_lib** in the namespace `vbotka`_
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `al_include_dir_vars.yml`_
   * `Special variable playbook_dir`_

ansible.cfg
^^^^^^^^^^^
   
.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^
   
.. literalinclude:: hosts
   :language: ini

al_vars
^^^^^^^

.. literalinclude:: al_vars/team/devel
   :language: yaml
   :caption:

.. literalinclude:: al_vars/team/production
   :language: yaml
   :caption:

.. literalinclude:: al_vars/team/qa
   :language: yaml
   :caption:

Expected results
^^^^^^^^^^^^^^^^

.. code-block:: yaml

   al_vars:
     team:
       devel:
         - team: devel
           users: [charlie, david]
       production:
         - team: production
           users: [alice, bob]
       qa:
         - team: qa1
           users: [mallory, ted]
         - team: qa2
           users: [darth, wendy]

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
   :emphasize-lines: 26-38
   :force:


.. _vbotka.freebsd.lib: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib/
.. _vbotka.ansible_lib: https://galaxy.ansible.com/ui/standalone/roles/vbotka/ansible_lib/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _al_include_dir_vars.yml: https://github.com/vbotka/ansible-lib/blob/master/tasks/al_include_dir_vars.yml

.. _Special variable playbook_dir: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-playbook_dir

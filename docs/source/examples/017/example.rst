.. _example_017:

017 community.general.iocage
----------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: inventory community.general.iocage; Example 017
   single: community.general.iocage; Example 017
   single: pb-iocage-obsolete.yml; Example 017
   single: option compose; Example 017
   single: compose; Example 017
   single: option groups; Example 017

Use case
^^^^^^^^

Use the `inventory plugin community.general.iocage`_ instead of the
:ref:`inventory plugin vbotka.freebsd.iocage <ug_inventory_iocage>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage.yml
  │   ├── 06_iocage.yml
  │   └── 99_constructed.yml
  ├── pb-iocage-obsolete.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Test the `inventory plugin community.general.iocage`_. It should provide the
    same functionality as the :ref:`inventory plugin vbotka.freebsd.iocage
    <ug_inventory_iocage>`

* On cloned jails in the group ``test``:

  * In the playbook ``pb-test.yml``:

    * Display jails and inventory groups.

.. important::

   The inventory plugin ``community.general.iocage`` may differ from
   ``vbotka.freebsd.iocage``. If you want to be sure
   ``community.general.iocage`` provides the same functionality, compare the
   hash from ``setup/vars/chcksum.yml`` with the ``community.general.iocage``
   hash. Run the included playbook ``pb-iocage-obsolete.yml``::

     shell> ansible-playbook pb-iocage-obsolete.yml

   If the versions are different, you will see a warning similar to this one::

     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
     *                     WARNING                                 *
     *                                                             *
     * The inventory plugins are different:                        *
     *                                                             *
     * vbotka.freebsd.iocage    db8039e6 0.4.7                     *
     * community.general.iocage 3057fb18 10.2.0                    *
     *                                                             *
     * Run the commands below to compare the functionality:        *
     *                                                             *
     *  shell> ansible-doc -t inventory vbotka.freebsd.iocage      *
     *  shell> ansible-doc -t inventory community.general.iocage   *
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *

   The play produces no warnings if the hashes match::

     shell> ANSIBLE_DISPLAY_OK_HOSTS=false \
            ANSIBLE_DISPLAY_SKIPPED_HOSTS=false \
            ansible-playbook pb-iocage-obsolete.yml

     PLAY [Test inventory plugin version.] ****************************************

     PLAY RECAP *******************************************************************
     localhost: ok=3 changed=0 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0

Notes
^^^^^

* Available in ``community.general`` >= 10.2.0.

.. hint::

   View the documentation from the command line:

   .. code:: console

      (env) > ansible-doc -t inventory community.general.iocage

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 1

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 1

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Graph
^^^^^

.. literalinclude:: out/out-01.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

.. hint::

   List all inventory::

     (env) > ansible-inventory -i hosts --list --yaml

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display jails and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

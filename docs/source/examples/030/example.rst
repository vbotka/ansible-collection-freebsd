.. _example_030:

030 Create custom facts
-----------------------

Extending example :ref:`example_020`.

.. contents::
   :local:
   :depth: 1

.. index:: single: custom facts; Example 030
.. index:: single: filter vbotka.freebsd.iocage; Example 030
.. index:: single: role vbotka.freebsd.iocage; Example 030

Use case
^^^^^^^^

Create custom facts to provide a dictionary of iocage datasets lists. Use the `filter
vbotka.freebsd.iocage`_ to parse them.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  ├── pb-iocage.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* At two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage.yml`` use the `role vbotka.freebsd.iocage`_ to:

  * create custom facts scripts.

  In the playbook ``pb-test.yml``:

  * get the custom facts
  * use the `filter vbotka.freebsd.iocage`_ to parse the custom facts
  * create the inventory group ``test`` and compose variables
  * display the hosts and composed variables in the group ``test``
  * display all groups.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* `filter vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* jails created in previous examples.

Notes
^^^^^

* See `Adding custom facts`_

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml

Playbook output - Display versions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini \
                                          -t freebsd_iocage_debug \
                                          -e freebsd_iocage_debug=true \
           | grep version

.. literalinclude:: out/out-03.txt
   :language: yaml

Playbook output - Create custom fact scripts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini \
                                          -t freebsd_iocage_facts \
                                          -e freebsd_iocage_facts=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Display custom fact script
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# cat /etc/ansible/facts.d/iocage.fact

.. literalinclude:: out/out-05.txt
   :language: python

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - Display custom facts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.ini

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:


.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _Adding custom facts: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#adding-custom-facts

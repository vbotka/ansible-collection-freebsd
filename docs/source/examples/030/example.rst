.. _example_030:

030 Create custom facts
-----------------------

Extending example :ref:`example_330`.

.. contents:: Table of Contents
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
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   └── iocage_02
  │       └── iocage.yml
  ├── iocage-hosts.ini
  ├── pb-iocage.yml
  └── pb-test-01.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage.yml* use the `role vbotka.freebsd.iocage`_ to:

  * create custom facts scripts.

  In the playbook *pb-test-01.yml*:

  * get the custom facts
  * use the `filter vbotka.freebsd.iocage`_ to parse the custom facts
  * create the inventory group *test* and compose variables
  * display the hosts and composed variables in the group *test*
  * display all groups.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* `filter vbotka.freebsd.iocage`_
* root privilege on the iocage hosts.
* jails created in previous examples.

Notes
^^^^^

* See `Adding custom facts`_
	       
List jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml

Playbook output - display versions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage.yml -i iocage-hosts.ini \
                                         -t freebsd_iocage_debug \
                                         -e freebsd_iocage_debug=true \
          | grep version

.. literalinclude:: out/out-03.txt
   :language: yaml

Create custom fact scripts
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage.yml -i iocage-hosts.ini \
                                         -t freebsd_iocage_facts \
					 -e freebsd_iocage_facts=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Display custom fact script
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  shell> ssh admin@10.1.0.18 cat /etc/ansible/facts.d/iocage.fact

.. literalinclude:: out/out-05.txt
   :language: python

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - display custom facts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-01.yml -i iocage-hosts.ini

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:


.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _Adding custom facts: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#adding-custom-facts

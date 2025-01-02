.. _example_017:

017 Inventory plugin community.general.iocage
---------------------------------------------

Extending example 016.

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 01_iocage.yml
   │   ├── 02_iocage.yml
   │   └── 03_constructed.yml
   └── pb-test.yml

Synopsis
^^^^^^^^

* The inventory plugin *community.general.iocage* provides the same functionality

Notes
^^^^^

   * Available in community.general >= 10.2.0
   * See ::

       shell> ansible-doc -t inventory community.general.iocage

Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml
    :emphasize-lines: 1

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml
    :emphasize-lines: 1

Inventory *hosts/03_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/03_constructed.yml
    :language: yaml
	       
Playbook *pb-test.yml*
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

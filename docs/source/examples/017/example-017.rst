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
   ├── pb-obsolete.yml
   └── pb-test.yml

Synopsis
^^^^^^^^

.. index:: single: inventory community.general.iocage; Example 017
.. index:: single: playbook pb-obsolete.yml; Example 017

The inventory plugin *community.general.iocage* should provide the same functionality.

.. warning::

   The inventory plugin *community.general.iocage* may differ from
   *vbotka.freebsd.iocage*. If you want be sure
   *community.general.iocage* provides the same functionality compare
   the hash from *setup/vars/chcksum.yml* with the
   *community.general.iocage* hash. Run the included playbook
   *pb-obsolete.yml* ::

     shell> ansible-playbook pb-obsolete.yml

   If the versions are different you'll see a warning similar to this one ::

     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
     *                  WARNING                                    *
     *                                                             *
     * The inventory plugins are different:                        *
     *                                                             *
     * vbotka.freebsd.iocage    db8039e6 0.4.7                     *
     * community.general.iocage 3057fb18 10.2.0                    *
     *                                                             *
     * Run the below commands and see the functionality provided   *
     *                                                             *
     *  shell> ansible-doc -t inventory vbotka.freebsd.iocage      *
     *  shell> ansible-doc -t inventory community.general.iocage   *
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *

   The play shows nothing if the hashes match ::

     shell> ANSIBLE_DISPLAY_OK_HOSTS=false \
            ANSIBLE_DISPLAY_SKIPPED_HOSTS=false \
	    ansible-playbook pb-obsolete.yml

     PLAY [Test inventory plugin version.] ****************************************

     PLAY RECAP *******************************************************************
     localhost: ok=3 changed=0 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0

       
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

.. _example_017:

017 community.general.iocage
----------------------------

Extending example :ref:`example_016`.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: inventory community.general.iocage; Example 017
.. index:: single: playbook pb-iocage-obsolete.yml; Example 017
.. index:: single: option compose; Example 017
.. index:: single: compose; Example 017
.. index:: single: option groups; Example 017

Use case
^^^^^^^^

Use the `inventory plugin community.general.iocage`_ instead of the `inventory
plugin vbotka.freebsd.iocage`_.

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
  ├── pb-iocage-obsolete.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

The `inventory plugin community.general.iocage`_ should provide the same
functionality.

.. warning::

   The inventory plugin ``community.general.iocage`` may differ from
   ``vbotka.freebsd.iocage``. If you want be sure ``community.general.iocage``
   provides the same functionality compare the hash from
   *setup/vars/chcksum.yml* with the ``community.general.iocage`` hash. Run the
   included playbook *pb-iocage-obsolete.yml* ::

     shell> ansible-playbook pb-iocage-obsolete.yml

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
            ansible-playbook pb-iocage-obsolete.yml

     PLAY [Test inventory plugin version.] ****************************************

     PLAY RECAP *******************************************************************
     localhost: ok=3 changed=0 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0


Notes
^^^^^

   * Available in community.general >= 10.2.0
   * See ::

       shell> ansible-doc -t inventory community.general.iocage

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml
    :caption:
    :emphasize-lines: 1

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml
    :caption:
    :emphasize-lines: 1

.. literalinclude:: hosts/03_constructed.yml
    :language: yaml
    :caption:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
    :language: yaml

Playbook output - display groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-01.txt
    :language: yaml
    :force:


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _inventory plugin community.general.iocage: https://docs.ansible.com/ansible/latest/collections/community/general/iocage_inventory.html

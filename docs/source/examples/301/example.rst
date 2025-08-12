.. _example_301:

301 Module vbotka.freebsd.ucl
-----------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.ucl; Example 301
.. index:: single: vbotka.freebsd.ucl; Example 301
.. index:: single: uclcmd; Example 301
.. index:: single: UCL (Universal Configuration Language); Example 301

Use case
^^^^^^^^

Test the `module vbotka.freebsd.ucl`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  ├── pb-test-01.yml
  └── pb-test-02.yml

Synopsis
^^^^^^^^

At a managed node :

* playbook ``pb-test-01.yml``: get ``FreeBSD.url`` from ``/etc/pkg/FreeBSD.conf``
* playbook ``pb-test-02.yml``: update ``FreeBSD.enabled`` in ``/etc/pkg/FreeBSD.conf``

Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.ucl`_
* installed `uclcmd`_

Notes
^^^^^

* TBD

.. seealso::

  * `uclcmd Command line tool for working with UCL config files`_
  * `UCL (Universal Configuration Language)`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - Get FreeBSD.url
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

  (env) > ansible-playbook pb-test-01.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
   :language: yaml

Playbook output - Disable FreeBSD repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-02.yml -i iocage.ini --check --diff

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:


.. _module vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/
.. _uclcmd: https://www.freshports.org/devel/uclcmd/
.. _uclcmd Command line tool for working with UCL config files: https://www.freshports.org/devel/uclcmd/
.. _UCL (Universal Configuration Language): https://wiki.freebsd.org/UniversalConfigurationLanguage

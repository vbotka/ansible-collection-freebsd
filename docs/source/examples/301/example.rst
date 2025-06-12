.. _example_301:

301 Module vbotka.freebsd.ucl
-----------------------------

.. contents:: Table of Contents
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
  ├── iocage-hosts.ini
  ├── pb-test-01.yml
  └── pb-test-02.yml

Synopsis
^^^^^^^^

On *iocage* host:

* playbook pb-test-01.yml: get FreeBSD.url from /etc/pkg/FreeBSD.conf
* playbook pb-test-02.yml: update FreeBSD.enabled in /etc/pkg/FreeBSD.conf

Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.ucl`_.

Notes
^^^^^

* TBD

.. seealso::

  * `uclcmd Command line tool for working with UCL config files`_
  * `UCL (Universal Configuration Language)`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output - get FreeBSD.url
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-01.yml -i iocage-hosts.ini
	       
.. literalinclude:: out/out-01.txt
    :language: yaml
    :force:

Playbook *pb-test-02.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
    :language: yaml

Playbook output - disable FreeBSD repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-02.yml -i iocage-hosts.ini --check --diff
	       
.. literalinclude:: out/out-02.txt
    :language: yaml
    :force:


.. _module vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/
.. _uclcmd Command line tool for working with UCL config files: https://www.freshports.org/devel/uclcmd/
.. _UCL (Universal Configuration Language): https://wiki.freebsd.org/UniversalConfigurationLanguage

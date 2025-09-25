.. _example_502:

502 branch-server
-----------------

.. contents::
   :local:
   :depth: 1

.. index:: single: branch-server; Example 502
.. index:: single: log server; Example 502


Use case
^^^^^^^^

Install and configure ``syslog-ng`` and ``apache`` servers in the ``branch-server``.

Tree
^^^^

::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── hosts
  ├── host_vars
  │   └── branch-server.example.com
  │       ├── apache.yml
  │       ├── certificate.yml
  │       ├── common.yml
  │       └── syslog-ng.yml
  ├── pb-apache.yml
  ├── pb-certificate.yml
  └── pb-logserv.yml

Synopsis
^^^^^^^^

* At the managed node ``branch-server.example.com``:

  * setup role `vbotka.freebsd.certificate`_
  * create SSL certificate for ``branch-server.example.com``
  * install ``www/apache24`` and configure ``Apache HTTP Server``
  * install ``sysutils/syslog-ng`` and configure ``Log Server``.

Requirements
^^^^^^^^^^^^

roles:

* `vbotka.freebsd.apache`_
* `vbotka.freebsd.certificate`_
* `vbotka.freebsd.postinstall`_

Notes
^^^^^

TBD

.. seealso::

   * :ref:`example_430`
   * :ref:`example_500`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts
   :language: ini
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/branch-server.example.com/common.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/certificate.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/apache.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/syslog-ng.yml
   :language: yaml
   :caption:

Playbook pb-certificate.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-certificate.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -t certificate_debug -e certificate_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -t certificate_setup

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - Create certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -t certificate_openssl 

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - Display status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -t certificate_openssl_stat

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook pb-apache.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-apache.yml
   :language: yaml+jinja

Playbook output - Apache HTTP server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-apache.yml

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserv.yml
   :language: yaml+jinja

Playbook output - Log server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logserv.yml -e install=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:


.. _vbotka.freebsd.apache:  https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/
.. _vbotka.freebsd.certificate:  https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate/
.. _vbotka.freebsd.postinstall:  https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/

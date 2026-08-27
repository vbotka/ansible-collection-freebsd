.. _example_430:

430 Role vbotka.freebsd.apache HTTPS
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: certificate; Example 430
.. index:: single: SSL certificate; Example 430
.. index:: single: role vbotka.freebsd.certificate; Example 430
.. index:: single: vbotka.freebsd.certificate; Example 430

.. index:: single: Apache HTTP Server; Example 430
.. index:: single: role vbotka.freebsd.apache; Example 430
.. index:: single: vbotka.freebsd.apache; Example 430

.. index:: single: iocage host_hostname; Example 430
.. index:: single: host_hostname; Example 430


Use case
^^^^^^^^

Use the role `vbotka.freebsd.certificate`_ to create SSL certificate. Use the role
`vbotka.freebsd.apache`_ to configure `Apache HTTP Server - SSL/TLS Strong Encryption`_. Use iocage
property ``host_hostname`` to create a jail.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  ├── host_vars
  │   ├── iocage_04
  │   │   └── ansible-client-apache.yml
  │   └── www-2
  │       ├── apache.yml
  │       └── certificate.yml
  ├── iocage.ini
  ├── pb-apache.yml
  └── pb-certificate.yml

Synopsis
^^^^^^^^

* The playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ creates and starts one jail.

* The playbook ``pb-certificate.yml`` creates SSL certificate in the jail.

* The playbook ``pb-apache.yml`` uses the certificate and configures `Apache HTTP Server`_ in the
  jail.

Requirements
^^^^^^^^^^^^

* Template ``ansible_client_apache`` created in :ref:`example_209`

Notes
^^^^^

* ``iocage`` option ``--name`` provides "NAME instead of a UUID for the new jail".

* ``iocage`` property ``host_hostname`` provides "The hostname of the jail. Default: UUID".

* Make sure DHCP and dynamic DNS are configured so that ``host_hostname`` and
  ``--name`` resolve.

.. seealso::

   * `FreeBSD Handbook 32.9. Apache HTTP Server`_
   * `FreeBSD Handbook 32.9.3.1. SSL support`_
   * `Apache HTTP Server`_
   * `Apache HTTP Server - SSL/TLS Strong Encryption`_
   * `man 8 iocage`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/ansible-client-apache.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/www-2/apache.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/www-2/certificate.yml
   :language: yaml
   :caption:

Create and start the jail
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage.ini \
                            -t clone_host_hostname -e clone_host_hostname=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts
   :language: ini
   :caption:

Playbook pb-certificate.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-certificate.yml
   :language: yaml

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -i hosts \
                            -t certificate_debug -e certificate_debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -i hosts -t certificate_setup

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - Create certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -i hosts -t certificate_openssl

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - Display status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-certificate.yml -i hosts -t certificate_openssl_stat

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-apache.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-apache.yml
   :language: yaml

Playbook output - Create server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-apache.yml -i hosts

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Results
^^^^^^^

* Certificate

  .. literalinclude:: out/out-06.txt
     :language: console

* Test the configuration

  .. code-block:: console

     (env) > ssh admin@www-2 sudo service apache24 configtest
     Performing sanity check on apache24 configuration:
     Syntax OK

* In a browser, open the page ``https//www-2/``. The content should be ::

    It works!


.. _vbotka.freebsd.apache: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/
.. _vbotka.freebsd.certificate: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate/
.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml

.. _FreeBSD Handbook 32.9. Apache HTTP Server: https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache
.. _FreeBSD Handbook 32.9.3.1. SSL support: https://docs.freebsd.org/en/books/handbook/network-servers/#_ssl_support
.. _Apache HTTP Server: https://httpd.apache.org/
.. _Apache HTTP Server - SSL/TLS Strong Encryption: https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html
.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage

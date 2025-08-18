.. _example_431:

431 Role vbotka.freebsd.apache Virtual Host
-------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: Apache Virtual Host; Example 431
.. index:: single: Apache HTTP Server; Example 431
.. index:: single: role vbotka.freebsd.apache; Example 431
.. index:: single: vbotka.freebsd.apache; Example 431

.. index:: single: certificate; Example 431
.. index:: single: SSL certificate; Example 431
.. index:: single: role vbotka.freebsd.certificate; Example 431
.. index:: single: vbotka.freebsd.certificate; Example 4311

.. index:: single: iocage host_hostname; Example 431
.. index:: single: host_hostname; Example 431


Use case
^^^^^^^^

Use the role `vbotka.freebsd.certificate`_ to create SSL certificate. Use the role
`vbotka.freebsd.apache`_ to configure `Apache HTTP Server Virtual Host`_. Use iocage
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
  │   └── www-3
  │       ├── apache.yml
  │       └── certificate.yml
  ├── iocage.ini
  ├── pb-apache.yml
  └── pb-certificate.yml

Synopsis
^^^^^^^^

* The playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ creates and starts one jail.

* The playbook ``pb-certificate.yml`` creates SSL certificate in the jail.

* The playbook ``pb-apache.yml`` uses the certificate and configures `Apache HTTP Server Virtual
  Host`_ in the jail.

Requirements
^^^^^^^^^^^^

* Template ``ansible_client_apache`` created in :ref:`example_209`

Notes
^^^^^

* ``iocage`` property ``host_hostname`` provides "The hostname of the jail.". Please note that ``iocage`` option ``--name`` provides "NAME instead of a UUID for the new jail".

* In case of DHCP, ``host_hostname`` resolves, however ``--name`` does not.

.. seealso::

   * `Apache HTTP Server Virtual Host`_
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

.. literalinclude:: host_vars/www-3/apache.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/www-3/certificate.yml
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

Create data-foo-bar
^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ssh admin@www-3 sudo cp -r /usr/local/www/apache24/data /usr/local/www/apache24/data-foo-bar
      
Results
^^^^^^^

Open the page in a browser ``https//www.foo.bar/``. The content should be ::

  It works!


.. _Apache HTTP Server: https://httpd.apache.org/
.. _Apache HTTP Server Virtual Host: https://httpd.apache.org/docs/2.4/vhosts/
.. _Apache HTTP Server - SSL/TLS Strong Encryption: https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html
.. _vbotka.freebsd.apache: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/
.. _vbotka.freebsd.certificate: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate/
.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml

.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage

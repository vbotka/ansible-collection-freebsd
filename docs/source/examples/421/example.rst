.. _example_421:

421 Role vbotka.freebsd.apache Virtual Host
-------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: Apache Virtual Host; Example 421
.. index:: single: Apache HTTP Server; Example 421
.. index:: single: role vbotka.freebsd.apache; Example 421
.. index:: single: vbotka.freebsd.apache; Example 421

.. index:: single: certificate; Example 421
.. index:: single: SSL certificate; Example 421
.. index:: single: role vbotka.freebsd.certificate; Example 421
.. index:: single: vbotka.freebsd.certificate; Example 421


Use case
^^^^^^^^

Use the role `vbotka.freebsd.certificate`_ to create SSL certificate. Use the
role `vbotka.freebsd.apache`_ to configure `Apache HTTP Server Virtual Host`_
``www.foo.bar``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_06
  │   │   └── ansible-client-apache.yml
  │   └── www_3
  │       ├── apache.yml
  │       └── certificate.yml
  ├── iocage.ini
  ├── pb-apache.yml
  ├── pb-certificate.yml
  └── pb-data.yml

Synopsis
^^^^^^^^

On a managed node:

* The playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ creates and
  starts one jail.

* The playbook ``pb-certificate.yml`` creates SSL certificate for
  ``www.foo.bar``.

* The playbook ``pb-data.yml`` creates data for ``www.foo.bar``.

* The playbook ``pb-apache.yml`` uses the certificate, configures, and starts
  `Apache HTTP Server Virtual Host`_ ``www.foo.bar`` in the jail.

Requirements
^^^^^^^^^^^^

* Template ``ansible-client-apache`` created in :ref:`example_209`

Notes
^^^^^

TBD

.. seealso::

   * `FreeBSD Handbook 32.9. Apache HTTP Server`_
   * `FreeBSD Handbook 32.9.2. Virtual Hosting`_
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

hosts
^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/ansible-client-apache.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/www_3/apache.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/www_3/certificate.yml
   :language: yaml+jinja
   :caption:

Create and start the jail
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone_host_hostname -e clone_host_hostname=true \
			    vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook pb-certificate.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-certificate.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts \
                            -t certificate_debug -e certificate_debug=true \
			    pb-certificate.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_setup pb-certificate.yml

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - Create certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_openssl pb-certificate.yml

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - Display status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_openssl_stat pb-certificate.yml

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-data.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-data.yml
   :language: yaml+jinja

Playbook output - Create data for Apache HTTP Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-data.yml

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook pb-apache.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-apache.yml
   :language: yaml+jinja

Playbook output - Configure and start server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-apache.yml

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Inventory graph
^^^^^^^^^^^^^^^
.. code-block:: console

   shell > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-08.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-09.txt
   :language: sh
      
Results
^^^^^^^

* Test the configuration

  .. code-block:: console

     [iocage_06]# iocage exec www-3 service apache24 configtest
     Performing sanity check on apache24 configuration:
     Syntax OK

* Test the server is running

  .. code-block:: console

     [iocage_06]# iocage exec www-3 service apache24 status
     apache24 is running as pid 24921.

* Test the server is working. See the IP in the list of the jails.

  .. code-block:: console

     [iocage_06]# lynx <IP>

     It works!

* Test SSL

  .. code-block:: console

     [iocage_06]# lynx https://<IP>

     It works!


  .. note::

     The browser will complain about self-signed certificate.

* In a browser, open the page ``https://www.foo.bar/``. If the URL
  resolves the content should be ::

    It works!


.. _Apache HTTP Server - SSL/TLS Strong Encryption: https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html
.. _vbotka.freebsd.apache: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/
.. _vbotka.freebsd.certificate: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate/
.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml

.. _FreeBSD Handbook 32.9. Apache HTTP Server: https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache
.. _FreeBSD Handbook 32.9.2. Virtual Hosting: https://docs.freebsd.org/en/books/handbook/network-servers/#_virtual_hosting
.. _Apache HTTP Server: https://httpd.apache.org/
.. _Apache HTTP Server Virtual Host: https://httpd.apache.org/docs/2.4/vhosts/
.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage

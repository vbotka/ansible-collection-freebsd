.. _example_430:

430 Role vbotka.freebsd.apache HTTPS
------------------------------------

(WIP)

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

Use case
^^^^^^^^

Use the role `vbotka.freebsd.certificate`_ to create an SSL
certificate. Use the role `vbotka.freebsd.apache`_ to configure
`Apache HTTP Server - SSL/TLS Strong Encryption`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_06
  │   │   └── ansible-client-apache.yml
  │   └── www_2
  │       ├── apache.yml
  │       └── certificate.yml
  ├── iocage.ini
  ├── pb-apache.yml
  └── pb-certificate.yml

Synopsis
^^^^^^^^

On a managed node:

* The playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ creates
  and starts a jail.

* The playbook ``pb-certificate.yml`` creates an SSL certificate in
  the jail.

* The playbook ``pb-apache.yml`` uses the certificate, then configures
  and starts `Apache HTTP Server`_ in the jail.

Requirements
^^^^^^^^^^^^

* Template ``ansible-client-apache`` created in :ref:`example_209`.

Notes
^^^^^

TBD

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

.. literalinclude:: host_vars/www_2/apache.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/www_2/certificate.yml
   :language: yaml+jinja
   :caption:

Create and start the jail
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t create_host -e create_host=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
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
   :language: yaml+jinja
   :force:

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_setup pb-certificate.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Playbook output - Create certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_openssl pb-certificate.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook output - Display status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_openssl_stat pb-certificate.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-apache.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-apache.yml
   :language: yaml+jinja

Playbook output - Configure and start server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-apache.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-inventory -i hosts --graph

.. literalinclude:: out/out-08.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-09.txt
   :language: sh

Results
^^^^^^^

* Certificate:

  .. code-block:: console

     shell> ssh admin@iocage_06 sudo iocage exec www-2 -- \
            'openssl x509 -in /usr/local/etc/ssl/certs/www-2.crt \
                          -text -noout -certopt no_pubkey,no_sigdump'

  .. literalinclude:: out/out-06.txt
     :language: yaml+jinja

* Test the configuration:

  .. code-block:: console

     [iocage_06]# iocage exec www-2 service apache24 configtest
     Performing sanity check on apache24 configuration:
     Syntax OK

* Test that the server is running:

  .. code-block:: console

     [iocage_06]# iocage exec www-2 service apache24 status
     apache24 is running as pid 47937.

* Test SSL:

  .. code-block:: console

     [iocage_06]# lynx https://<IP>

     It works!

  .. note::

     The browser will complain about a self-signed certificate.

* In a browser, open the page ``https://www-2/``. If the URL resolves,
  the content should be::

    It works!

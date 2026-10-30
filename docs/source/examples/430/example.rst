.. _example_430:

430 Role vbotka.freebsd.apache HTTPS
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: certificate; Example 430
   single: SSL certificate; Example 430
   single: role vbotka.freebsd.certificate; Example 430
   single: vbotka.freebsd.certificate; Example 430
   single: Apache HTTP Server; Example 430
   single: role vbotka.freebsd.apache; Example 430
   single: vbotka.freebsd.apache; Example 430
   single: template ansible-apache; Example 430
   single: ansible-apache; Example 430

Use case
^^^^^^^^

Use the role `vbotka.freebsd.certificate`_ to create an `SSL certificate`_. Use
the role `vbotka.freebsd.apache`_ to configure `Apache HTTP Server - SSL/TLS
Strong Encryption`_.

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
  │   │   └── apache.yml
  │   └── www_2
  │       ├── apache.yml
  │       └── certificate.yml
  ├── iocage.ini
  ├── pb-apache.yml
  └── pb-certificate.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-ansible-clients`, create jails from the
    template ``ansible-apache``.

* On the created jails:

  * In the playbook ``pb-certificate.yml``, create an `SSL certificate`_ for ``www-2``.
  * Dump the certificate.
  * In the playbook ``pb-apache.yml``, configure and start `Apache HTTP Server`_.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.apache`_
* Role `vbotka.freebsd.certificate`_
* Playbook :ref:`ug_pb-iocage-ansible-clients`
* Template ``ansible-apache`` created in :ref:`example_209`

Notes
^^^^^

* TBD.

.. note::

   | `vbotka.freebsd.apache`_ is the role **apache** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_apache`_ is the role **freebsd_apache** in the namespace `vbotka`_.
   | `vbotka.freebsd.certificate`_ is the role **certificate** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_certificate`_ is the role **freebsd_certificate** in the namespace `vbotka`_.

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

.. literalinclude:: host_vars/iocage_06/apache.yml
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
                            -t clone -e clone=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

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

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_setup pb-certificate.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook output - Create certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_openssl pb-certificate.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook output - Display status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -t certificate_openssl_stat pb-certificate.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

Certificate
^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage exec www-2 -- \
         'openssl x509 -in /usr/local/etc/ssl/certs/www-2.crt \
                       -text -noout -certopt no_pubkey,no_sigdump'

.. literalinclude:: out/out-08.txt
   :language: console

Playbook pb-apache.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-apache.yml
   :language: yaml+jinja

Playbook output - Configure and start Apache
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-apache.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:

Results
^^^^^^^

* Test the configuration:

  .. literalinclude:: out/out-10.txt
     :language: console
     :caption: [iocage_06]# iocage exec www-2 service apache24 configtest

* Test that the server is running:

  .. literalinclude:: out/out-11.txt
     :language: console
     :caption: [iocage_06]# iocage exec www-2 service apache24 status

* Test that the server is working (see the IP in the list of jails):

  .. code-block:: console
     :caption: [iocage_06]# lynx <IP>

     It works!

* Test SSL:

  .. code-block:: console
     :caption: [iocage_06]# lynx https://<IP>

     It works!

  .. note::

     The browser will complain about the self-signed certificate.

* In a browser, open the page ``https://www-2/``. If the URL resolves, the
  content should be::

    It works!

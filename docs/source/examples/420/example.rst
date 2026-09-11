.. _example_420:

420 Role vbotka.freebsd.apache
------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: Apache HTTP Server; Example 420
.. index:: single: role vbotka.freebsd.apache; Example 420
.. index:: single: vbotka.freebsd.apache; Example 420

.. index:: single: iocage host_hostname; Example 420
.. index:: single: host_hostname; Example 420

Use case
^^^^^^^^

Use the role `vbotka.freebsd.apache`_ to configure `Apache HTTP
Server`_.

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
  │   └── www_1
  │       └── apache.yml
  ├── iocage.ini
  └── pb-apache.yml

Synopsis
^^^^^^^^

On a managed node:

* The playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ creates
  and starts a jail.

* The playbook ``pb-apache.yml`` configures `Apache HTTP Server`_ in
  the jail.

Requirements
^^^^^^^^^^^^

* Template ``ansible-client-apache`` created in :ref:`example_209`.

Notes
^^^^^

* ``iocage`` option ``--name`` provides "NAME instead of a UUID for
  the new jail".

* ``iocage`` property ``host_hostname`` provides "The hostname of the
  jail. Default: UUID".

* Make sure DHCP and dynamic DNS are configured so that
  ``host_hostname`` and ``--name`` resolve.

.. seealso::

   * `FreeBSD Handbook 32.9. Apache HTTP Server`_
   * `Apache HTTP Server`_
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

The value of the iocage tag ``alias`` is used as the inventory alias.

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/ansible-client-apache.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/www_1/apache.yml
   :language: yaml+jinja
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t create_host -e create_host=true \
                            -e debug=true -e debug2=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
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

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-inventory -i hosts --graph

.. literalinclude:: out/out-03.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-04.txt
   :language: sh

Results
^^^^^^^

* Test the configuration:

  .. code-block:: console

     [iocage_06]# iocage exec www-1 service apache24 configtest
     Performing sanity check on apache24 configuration:
     Syntax OK

* Test that the server is running:

  .. code-block:: console

     [iocage_06]# iocage exec www-1 service apache24 status
     apache24 is running as pid 57456.

* Test that the server is working (see the IP in the list of jails):

  .. code-block:: console

     [iocage_06]# lynx <IP>

     It works!

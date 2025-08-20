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

 Use iocage property ``host_hostname`` to create a jail. Use the role `vbotka.freebsd.apache`_ to
 configure `Apache HTTP Server`_.

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
  │   └── www-1
  │       └── apache.yml
  ├── iocage.ini
  └── pb-apache.yml

Synopsis
^^^^^^^^

* The playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ creates and starts one jail.
* The playbook ``pb-apache.yml`` configures `Apache HTTP Server`_ in the jail.

Requirements
^^^^^^^^^^^^

* Template ``ansible_client_apache`` created in :ref:`example_209`

Notes
^^^^^

* ``iocage`` property ``host_hostname`` provides "The hostname of the jail.". Please note that ``iocage`` option ``--name`` provides "NAME instead of a UUID for the new jail".

* In case of DHCP, ``host_hostname`` resolves, however ``--name`` does not.

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

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/ansible-client-apache.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/www-1/apache.yml
   :language: yaml
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage.ini \
			    -t clone_host_hostname -e clone_host_hostname=true \
			    -e debug=true -e debug2=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts
   :language: ini
   :caption:

Playbook pb-apache.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-apache.yml
   :language: yaml

Playbook output - Create server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-apache.yml -i hosts

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Results
^^^^^^^

* Test the configuration

  .. code-block:: console

     (env) > ssh admin@www-1 sudo service apache24 configtest
     Performing sanity check on apache24 configuration:
     Syntax OK

* In a browser, open the page ``http://www-1/``. The content should be ::

    It works!


.. _vbotka.freebsd.apache: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache/
.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml

.. _FreeBSD Handbook 32.9. Apache HTTP Server: https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache
.. _Apache HTTP Server: https://httpd.apache.org/
.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage

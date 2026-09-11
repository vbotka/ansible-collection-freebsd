.. _example_200:

200 Create iocage templates. Clone jails.
-----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_client; Example 200
.. index:: single: template ansible_client; Example 200
.. index:: single: sudoers; Example 200

.. index:: single: pb_iocage_template.yml; Example 200
.. index:: single: pb_iocage_ansible_clients.yml; Example 200

.. index:: single: inventory vbotka.freebsd.iocage; Example 200
.. index:: single: module vbotka.freebsd.iocage; Example 200
.. index:: single: module ansible.posix.authorized; Example 200
.. index:: single: ansible.posix.authorized; Example 200
.. index:: single: module ansible.builtin.lineinfile; Example 200
.. index:: single: ansible.builtin.lineinfile; Example 200
.. index:: single: module community.general.sysrc; Example 200
.. index:: single: community.general.sysrc; Example 200

.. index:: single: option compose; Example 200
.. index:: single: compose; Example 200
.. index:: single: option groups; Example 200

.. index:: single: act_user; Example 200
.. index:: single: act_pk; Example 200
.. index:: single: act_sudo; Example 200
.. index:: single: act_rcconf; Example 200
.. index:: single: pkglist; Example 200
.. index:: single: pkgs.json; Example 200

Use case
^^^^^^^^

Create `iocage`_ templates for Ansible clients. Clone jails.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pk_admins.txt
  │   └── pkgs.json
  ├── hosts
  │   ├── 02_iocage.yml
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook `vbotka.freebsd.pb_iocage_template.yml`_, use the
  modules:

  * ``vbotka.freebsd.iocage`` to create, start, stop, and convert jails to templates.
  * ``vbotka.freebsd.iocage`` exec tasks to create a user and set ``.ssh`` ownership.
  * ``ansible.posix.authorized_key`` to configure public keys.
  * ``community.general.sysrc`` to configure ``/etc/rc.conf``.
  * ``ansible.builtin.lineinfile`` to configure ``/usr/local/etc/sudoers``.

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_, use
  the `module vbotka.freebsd.iocage`_ to:

  * Create jails from the iocage templates
  * Start all jails
  * Optionally, display the lists of jails

* On all created jails:

  In the playbook ``pb-test.yml``:

  * Connect to created jails
  * Display basic configuration of the jails

Requirements
^^^^^^^^^^^^

* Playbook `vbotka.freebsd.pb_iocage_template.yml`_
* Playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* Root privileges on the managed nodes
* An activated ``iocage`` installation
* Fetched releases

Notes
^^^^^

* The playbook `vbotka.freebsd.pb_iocage_template.yml`_ expects to
  find the file ``pkgs.json`` in the directory ``files``. See the
  tasks ``playbooks/pb_iocage_template_pkglist.yml`` and
  :ref:`ug_pb-iocage-template`.

.. seealso::

   * `Using Templates`_
   * `Connection methods and details`_
   * `Understanding privilege escalation`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

files
^^^^^

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

.. note::

   The variables ``act_*`` are used to configure the template:

   * The user ``act_user`` will be created in the template.
   * The user ``act_user`` will serve as the Ansible ``remote_user``.
   * The file ``act_pk`` provides the public keys allowed to SSH to ``act_user`` in a jail.

.. warning::

   * The user ``act_user`` must exist on the ``iocage``
     host. Otherwise, the module ``ansible.posix.authorized_key`` will
     crash. See ``playbooks/pb_iocage_template/pk.yml``.

   * The file ``files/pk_admins.txt`` has been sanitized. Adjust the
     public keys to your needs::

       shell> cat files/pk_admins.txt
       ssh-rsa <sanitized> admin@controller

Playbook output - Create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

Templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash

Templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook output - Clone and start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone \
                            -e clone=true \
                             vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook output - List jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t list \
                            -e debug=true \
                             vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-07.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-08.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display test vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:

.. hint::

   The command below stops and destroys the cloned jails::

     ansible-playbook -i iocage.ini \
                      -t clone_destroy \
                      -e clone_destroy=true \
                       vbotka.freebsd.pb_iocage_ansible_clients.yml

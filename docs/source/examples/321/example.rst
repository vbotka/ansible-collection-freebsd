.. _example_321:

321 Configure package repository for Poudriere
----------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkg repo; Example 321
.. index:: single: pkg_repos_conf; Example 321
.. index:: single: signature_type; Example 321
.. index:: single: pubkey; Example 321
.. index:: single: mirror_type; Example 321
.. index:: single: role vbotka.freebsd.packages; Example 321
.. index:: single: vbotka.freebsd.packages; Example 321

Use case
^^^^^^^^

Use the role `vbotka.freebsd.packages`_ to configure a package repository for
`Poudriere`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── build.example.com-sk.crt
  ├── host_vars
  │   └── iocage_06
  │       └── repos.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

On a managed node, use the role `vbotka.freebsd.packages`_ to configure a
package repository for `Poudriere`_.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.packages`_
* :ref:`ug_filter_to_ucl`

Notes
^^^^^

* TBD

.. note::

   | `vbotka.freebsd.packages`_ is the role **packages** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_packages`_ is the role **freebsd_packages** in the namespace `vbotka`_.

.. seealso::

   * `Poudriere - Configure clients`_
   * `man pkg`_
   * `man pkg.conf`_

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

.. literalinclude:: host_vars/iocage_06/repos.yml
   :language: yaml+jinja
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Create repo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -t pkg_keys,pkg_conf pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Repository build.conf
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
   :caption: /usr/local/etc/pkg/repos/build.conf
   :language: yaml+jinja

Configuration
^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# pkg -vv

.. literalinclude:: out/out-03.txt
   :language: console

Update repos
^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# pkg update -f

.. literalinclude:: out/out-04.txt
   :language: console

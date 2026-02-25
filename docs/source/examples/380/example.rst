.. _example_380:

380 Configure custom image
--------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.custom_image; Example 380
.. index:: single: vbotka.freebsd.custom_image; Example 380

Use case
^^^^^^^^

Use the role `vbotka.freebsd.custom_image`_ to configure a custom image.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── vault.yml
  ├── hosts
  ├── host_vars
  │   └── images.example.com
  └── pb.yml

Synopsis
^^^^^^^^

* Use the playbook ``pb.yml`` at ``images.example.com`` to customize FreeBSD image:

  * configure wireless adapter `RTL8188EU`_
  * configure wpa_supplicant
  * connect to AP
    
Requirements
^^^^^^^^^^^^

* root privilege in the managed nodes.

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.custom_image`_ is the role **custom_image** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_custom_image`_ is the role **freebsd_custom_image** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `Get FreeBSD`_
   * `Memory Disks`_
   * `Wireless Networks`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/images.example.com
   :language: yaml
   :caption:

.. note:: The default values of ``cimage_download`` and ``cimage_unpack`` are ``true``. Set them to
          ``false`` and enable them when needed.

.. hint:: Put the variables ``my_access_point`` and ``my_password`` into an `vault`_ file. For
          example, ``group_vars/all/vault.yml``

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t cimage_debug -e cimage_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - Download images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t cimage_download -e cimage_download=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - Unpack images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t cimage_unpack -e cimage_unpack=true

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - Mount image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t cimage_mount

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - Customize image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t cimage_customize

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook output - Umount image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t cimage_umount

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook output - Mount, customize, and umount image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The play is not idempotent when the image is unmounted. The default is ``cimage_umount=true``. In
this case, at least 3 tasks are ``changed``. The image is mounted, unmounted, and the memory disk is
detached.

.. code-block:: console

   (env) > ansible-playbook pb.yml

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Write the image file to USB
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> dd if=FreeBSD-15.0-RELEASE-arm64-aarch64-RPI.img of=/dev/da1 bs=1m conv=sync status=progress
     5366611968 bytes (5367 MB, 5118 MiB) transferred 150.028s, 36 MB/s
   5120+0 records in
   5120+0 records out
   5368709120 bytes transferred in 150.164342 secs (35752224 bytes/sec)

.. note:: FreeBSD was used to write the image. In Linux, use ``bs=1M``
 
.. seealso::

   * `Writing an Image File to USB`_
   * `Best microSD Cards for Raspberry Pi 2025`_

Result
^^^^^^

MACs are sanitized.

.. code-block:: console

   (env) > ssh freebsd@10.1.0.16 dmesg

.. literalinclude:: out/out-08.txt
   :language: bash

     
.. _vbotka.freebsd.custom_image: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image/
.. _vbotka.freebsd_custom_image: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_custom_image/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _Get FreeBSD: https://www.freebsd.org/where
.. _Memory Disks: https://docs.freebsd.org/en/books/handbook/disks/#disks-virtual
.. _Wireless Networks: https://docs.freebsd.org/en/books/handbook/network/#network-wireless
.. _Writing an Image File to USB: https://docs.freebsd.org/en/books/handbook/bsdinstall/#bsdinstall-usb

.. _vault: https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html#encrypting-files-with-ansible-vault
.. _RTL8188EU: https://man.freebsd.org/cgi/man.cgi?query=rtwn&sektion=4&format=html
.. _Best microSD Cards for Raspberry Pi 2025: https://www.tomshardware.com/best-picks/raspberry-pi-microsd-cards

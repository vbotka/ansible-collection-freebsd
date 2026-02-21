.. _ug:

User's guide
############
.. contents:: Table of Contents
   :local:
   :depth: 1

.. _ug_introduction:

Introduction
************

The goal of this role is the customization of FreeBSD installation images. FreeBSD provides the
users with the option of `Release Building`_. The usage of this powerful tool to make small changes,
for example the configuration of the wireless network (see Quick start guide), would be an
overkill. Instead, this role provides the users with the options to mount `released images and
development snapshots`_, and customize them. The role can be easily configured and extended. The
users are expected to write playbooks and additional customization tasks when needed. When you
decide to customize the functionality consider the Ansible role `vbotka.config_light`_ instead of
creating additional custom tasks. The advantage would be unified configuration data in
`vbotka.config_light`_. Create custom tasks if the role `vbotka.config_light`_ is not able to do
what you want. `Contributions are welcome`_. See the examples in the directory `contrib`_.

Many tasks are disabled by default. They can be enabled and run one by one to accomplish standalone
tasks (see ``tasks/main.yml`` and ``defaults/main/main.yml``). By default, ``download, unpack,
mount, and umount`` are enabled. All included customization tasks are disabled by default (see
``tasks/customize.yml`` and ``default/main/customize.yml``). See :ref:`ug_tags` Examples and
:ref:`ug_bp` on how to enable and run tasks one by one.

By default, the role is not idempotent. In the standard workflow, an image is always mounted when
the role starts and unmounted when the customization completes. To speedup the repeating execution
of a playbook, disable the unmounting of the image by setting the variable
``cimage_umount=false``. This would make the role idempotent. Unmount the image before dumping it to
a disk.

* Ansible role: `vbotka.freebsd_custom_image`_
* Supported systems: `FreeBSD`_

.. _ug_installation:

Installation
************

.. index:: single: Ansible Galaxy; Installation
.. index:: single: ansible-galaxy; Installation

The most convenient way how to install an Ansible role is to use Ansible Galaxy CLI
``ansible-galaxy``. The utility comes with the standard Ansible package and provides the user with a
simple interface to the Ansible Galaxy's services. For example, look at the current status of the
role

.. code-block:: console

   shell> ansible-galaxy role info vbotka.freebsd_custom_image

and install it

.. code-block:: console

    shell> ansible-galaxy role install vbotka.freebsd_custom_image

Install the collections `community.general`_, `ansible.posix`_, and `vbotka.freebsd`_

.. code-block:: console

    shell> ansible-galaxy collection install ansible.posix
    shell> ansible-galaxy collection install community.general
    shell> ansible-galaxy collection install vbotka.freebsd

.. seealso::
   * To install specific versions from various sources see `Installing content`_.
   * Look at other roles ``shell> ansible-galaxy search --author=vbotka``

.. _ug_playbook:

Playbook
********

Below is a simple playbook ``playbook.yml`` that calls this role (9) for a single managed node
``images.example.com`` (1)

.. code-block:: yaml
   :emphasize-lines: 1,9
   :linenos:

   - hosts: images.example.com
     gather_facts: true
     connection: ssh
     remote_user: admin
     become: true
     become_user: root
     become_method: sudo
     roles:
       - vbotka.freebsd_custom_image

.. note::  To test sanity ``ansible_os_family``, ``gather_facts: true`` (2) must be enabled.

.. seealso::
   * For details see `Connection Plugins`_ (3-4)
   * See also `Understanding Privilege Escalation`_ (5-7)

.. _ug_debug:

Debug
*****

.. index:: single: cimage_debug; Debug

Some tasks will display additional information when the variable ``cimage_debug`` is enabled. Enable
debug output either in the configuration

.. code-block:: yaml
   :emphasize-lines: 1

   cimage_debug: true

, or set the extra variable in the command

.. code-block:: console
   :emphasize-lines: 1

   shell> ansible-playbook playbook.yml -e cimage_debug=true

.. note::

   The debug output of this role is optimized for the YAML format. Set it either in the environment
   ::

     shell> export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

   , or in the configuration ::

     [defaults]
     callback_result_format = yaml

.. seealso::
   * `Playbook Debugger`_
   * `Debugging modules`_
   * `Python Debugging With Pdb`_

.. _ug_tags:

Tags
****

.. index:: single: tags; Tags

The ``tags`` provide the user with a very useful tool to run selected tasks of the role. List the
role's tags to see what tags are available

.. include:: tags-list.rst

Basics
======

.. index:: single: cimage_debug; Basics
.. index:: single: cimage_sanity; Basics

* Display the variables. Use the tag ``cimage_debug`` and set ``cimage_debug: true``
  ::

    shell> ansible-playbook playbook.yml -t cimage_debug -e cimage_debug=true

* Download images ::

    shell> ansible-playbook playbook.yml -t cimage_download

* Unpack images ::

    shell> ansible-playbook playbook.yml -t cimage_unpack

* Create memory disk and mount the image ::

    shell> ansible-playbook playbook.yml -t cimage_mount

* Run sanity tests. Enable sanity ``cimage_sanity: true`` ::

    shell> ansible-playbook playbook.yml -t cimage_sanity -e cimage_sanity=true

* Customize the image ::

    shell> ansible-playbook playbook.yml -t cimage_customize

* Umount the image ::

    shell> ansible-playbook playbook.yml -t cimage_umount


.. _ug_tasks:

Customization tasks
*******************

.. index:: single: cimage_customize; Customization tasks

The description of the customization's tasks is not complete. The `role`_ and the documentation is
work in progress. Feel free to `share your feedback and report issues`_.

`Contributions are welcome`_.

.. seealso::
   * Source code :ref:`as_customize.yml`

All customization tasks are disabled by default. The default variables of these tasks are stored
under the same filenames in the directory ``defaults/main``. Enable, configure, and run these tasks as
needed. Keep this arrangement when you add custom tasks. Add custom tasks to the dictionary
``cimage_customize``

.. literalinclude:: ../../defaults/main/customize.yml
  :caption: `defaults/main/customize.yml`_
  :language: yaml

.. _ug_tasks_custom:

Included customization tasks
============================

.. toctree::

   task_loaderconf
   task_rcconf
   task_wpasupconf

.. hint:: Instead of creating more custom tasks, consider Ansible role `vbotka.config_light`_. See
          the example :ref:`ug_example_001`

.. _ug_vars:

Variables
*********

There are two categories of variables. The variables that control the workflow of the role (see
``defaults/main/main.yml``) and customization tasks variables (see other files in
``defaults/main``).

.. seealso:: `Ansible variable precedence. Where should I put a variable?`_

.. _ug_vars_defaults:
.. include:: vars-defaults.rst

.. _ug_bp:

Best practice
*************

* Create a playbook and test the syntax ::

   shell> ansible-playbook playbook.yml --syntax-check

* See what variables will be included ::

   shell> ansible-playbook playbook.yml -t cimage_debug -e cimage_debug=true

* Download images. To make the task idempotent use the attribute *checksum* in the items of the list
  *cimage_download_images*. See :ref:`ug_vars_defaults` ::

   shell> ansible-playbook playbook.yml -t cimage_download

* Unpack the images ::

   shell> ansible-playbook playbook.yml -t cimage_unpack
   
* Create memory disk and mount image ::

   shell> ansible-playbook playbook.yml -t cimage_mount

* Dry-run the customization of the image and see what will be changed ::

   shell> ansible-playbook  playbook.yml -t cimage_customize --check --diff
   
* Customize the image. Run the playbook and keep the image mounted. Review the changes. Repeated
  execution of the customization should be idempotent ::

   shell> ansible-playbook playbook.yml -t cimage_customize

* Umount the image and detach the memory disk ::

   shell> ansible-playbook playbook.yml -t cimage_umount

* Dump the customized image to a disk and boot it ::

    shell> dd if=image.img of=/dev/mmcsd0 bs=1m conv=sync status=progress

.. hint:: In Linux, use ``bs=1M``

* Keep the image mounted if you want to run the playbook periodically. In this case, repeated
  execution of the playbook should be idempotent ::

    shell> ansible-playbook playbook.yml -e cimage_umount=false

  However, the mountpoint is not configured in ``/etc/fstab`` and won't survive a reboot. If this is
  a problem, put the configuration of the memory disk into ``/etc/rc.conf`` and configure the
  mountpoint in ``/etc/fstab``.

.. _ug_examples:

Examples
********

.. toctree::
   :name: examples_toc

   example-wifi-basic-cl
   example-wpacli-cl
   example-003


.. _role: https://galaxy.ansible.com/vbotka/freebsd_custom_image
.. _vbotka.freebsd_custom_image: https://galaxy.ansible.com/vbotka/freebsd_custom_image
.. _vbotka.config_light: https://galaxy.ansible.com/vbotka/config_light

.. _community.general: https://docs.ansible.com/ansible/latest/collections/community/general
.. _ansible.posix: https://docs.ansible.com/ansible/latest/collections/ansible/posix
.. _vbotka.freebsd: https://ansible-collection-freebsd.readthedocs.io/en/latest/

.. _Release Building: https://www.freebsd.org/doc/en/articles/releng/release-build.html
.. _released images and development snapshots: https://www.freebsd.org/where.html

.. _Contributions are welcome: https://github.com/firstcontributions/first-contributions
.. _share your feedback and report issues: https://github.com/vbotka/ansible-freebsd-custom-image/issues
.. _contrib: https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/contrib

.. _FreeBSD: https://www.freebsd.org/releases
.. _Installing content: https://galaxy.ansible.com/docs/using/installing.html
.. _Connection Plugins: https://docs.ansible.com/ansible/latest/plugins/connection.html
.. _Understanding Privilege Escalation: https://docs.ansible.com/ansible/latest/user_guide/become.html#understanding-privilege-escalation
.. _Playbook Debugger: https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html
.. _Debugging modules: https://docs.ansible.com/ansible/latest/dev_guide/debugging.html#debugging-modules
.. _Python Debugging With Pdb: https://realpython.com/python-debugging-pdb
.. _Ansible variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable

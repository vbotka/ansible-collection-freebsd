.. _ug:

############
User's guide
############
.. contents:: Table of Contents
   :depth: 3


.. _ug_introduction:

************
Introduction
************

The goal of this role is the customization of FreeBSD installation images. FreeBSD provides the
users with the option of `Release Building
<https://www.freebsd.org/doc/en/articles/releng/release-build.html>`_. The usage of this powerful
tool to make small changes, e.g. the configuration of wireless network (see Quick start guide),
would be an overkill. Instead, this role provides the users with the options to mount `released
images and development snapshots <https://www.freebsd.org/where.html>`_, and customize them. The
role can be easily configured and extended. The users are expected to write playbooks and additional
customization tasks when needed. When you decide to customize the functionality consider Ansible
role `vbotka.config_light <https://galaxy.ansible.com/vbotka/config_light>`_ instead of creating
additional custom tasks. The advantage would be unified configuration data in
``config_light``. Create custom tasks if ``config_light`` is not able to do what you
want. `Contributions are welcome <https://github.com/firstcontributions/first-contributions>`_. See
the examples in the directory `contrib
<https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/contrib/>`_.

Many of the tasks in the workflow are disabled by default and can be enabled and run one by one to
accomplish standalone tasks (see *tasks/main.yml* and *defaults/main.yml*). By default, *sanity,
mount, customize, and umount* are enabled. All included customization tasks are disabled by default
(see *tasks/customize*). See :ref:`ug_tags` Examples and :ref:`ug_bp` on how to enable and run tasks
one by one.

By default, the role is not idempotent. In the standard workflow, an image is always mounted when
the role starts and unmounted when completes. To speedup repeating execution of a playbook, it's
possible to disable the unmounting of the image by setting the variable
``cimage_umount=false``. This would make the role idempotent. Unmount the image before dumping
it to a disk.


* Ansible role: `vbotka.freebsd_custom_image <https://galaxy.ansible.com/vbotka/freebsd_custom_image/>`_
* Supported systems: `FreeBSD <https://www.freebsd.org/releases/>`_
* Requirements: `vbotka.ansible_lib <https://galaxy.ansible.com/vbotka/ansible_lib>`_


.. _ug_installation:

************
Installation
************

The most convenient way how to install an Ansible role is to use :index:`Ansible Galaxy` CLI
``ansible-galaxy``. The utility comes with the standard Ansible package and provides the user with a
simple interface to the Ansible Galaxy's services. For example, take a look at the current status of
the role ::

   shell> ansible-galaxy role info vbotka.freebsd_custom_image

and install it ::

    shell> ansible-galaxy role install vbotka.freebsd_custom_image

* Install the library ``vbotka.ansible_lib`` ::

    shell> ansible-galaxy role install vbotka.ansible_lib

* Install the collections
  `community.general <https://docs.ansible.com/ansible/latest/collections/community/general/>`_
  and `ansible.posix <https://docs.ansible.com/ansible/latest/collections/ansible/posix/index.html#plugins-in-ansible-posix/>`_  ::

    shell> ansible-galaxy collection install ansible.posix
    shell> ansible-galaxy collection install community.general

.. seealso::
   * To install specific versions from various sources see `Installing content <https://galaxy.ansible.com/docs/using/installing.html>`_.
   * Take a look at other roles ``shell> ansible-galaxy search --author=vbotka``


.. _ug_playbook:

********
Playbook
********

Below is a simple playbook that calls this role (10) for a single host images.example.com (2)

.. code-block:: bash
   :emphasize-lines: 1,2,10
   :linenos:

   shell> cat playbook.yml
   - hosts: images.example.com
     gather_facts: true
     connection: ssh
     remote_user: admin
     become: true
     become_user: root
     become_method: sudo
     roles:
       - vbotka.freebsd_custom_image

.. note:: ``gather_facts: true`` (3) must be set to test sanity ``ansible_os_family``

.. seealso::
   * For details see `Connection Plugins <https://docs.ansible.com/ansible/latest/plugins/connection.html>`__ (4-5)
   * See also `Understanding Privilege Escalation <https://docs.ansible.com/ansible/latest/user_guide/become.html#understanding-privilege-escalation>`__ (6-8)


.. _ug_debug:

*****
Debug
*****

Some tasks will display additional information when the variable :index:`cimage_debug` is
enabled. Enable debug output either in the configuration

.. code-block:: yaml
   :emphasize-lines: 1

   cimage_debug: true

, or set the extra variable in the command

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook playbook.yml -e cimage_debug=true

.. note:: The debug output of this role is optimized for the **yaml** callback plugin. Set this
   plugin for example in the environment ``shell> export ANSIBLE_STDOUT_CALLBACK=yaml``.

.. seealso::
   * `Playbook Debugger <https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html>`_
   * `Debugging modules <https://docs.ansible.com/ansible/latest/dev_guide/debugging.html#debugging-modules>`_
   * `Python Debugging With Pdb <https://realpython.com/python-debugging-pdb/>`_


.. _ug_tags:

****
Tags
****

The :index:`tags` provide the user with a very useful tool to run selected
tasks of the role. To see what tags are available list the tags of the
role with the command

.. include:: tags-list.rst


Basics
======

* Display the variables. Use the tag ``cimage_debug``. Enable :index:`debug` (``cimage_debug: true``)

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_debug -e cimage_debug=true

* Download images

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_download

* Unpack images

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_unpack

* Create memory disk and mount the image

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_mount

* Run sanity tests. Enable :index:`sanity` (``cimage_sanity: true``)

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_mount

* Customize the image

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_customize

* Umount the image

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook playbook.yml -t cimage_umount


.. _ug_tasks:

*******************
Customization tasks
*******************

The description of the customization's tasks is not complete. The `role
<https://galaxy.ansible.com/vbotka/freebsd_custom_image/>`_ and the documentation is work in
progress. Feel free to `share your feedback and report issues
<https://github.com/vbotka/ansible-freebsd-custom-image/issues>`_.

`Contributions are welcome <https://github.com/firstcontributions/first-contributions>`_. 

.. seealso::
   * Source code :ref:`as_customize.yml`

All customization tasks are disabled by default. The default variables of these tasks are stored
under the same file-names in the directory *defaults/main*. Enable, configure and run these tasks as
needed. Keep this arrangement when you add custom tasks.

.. toctree::

   task_loaderconf
   task_rcconf
   task_wpasupconf

.. note:: Instead of creating additional custom tasks, consider Ansible role `config_light
          <https://galaxy.ansible.com/vbotka/config_light>`_. See :ref:`ug_example_001`


.. _ug_vars:

*********
Variables
*********

There are two categories of variables. The variables that control the workflow of the role (see
*default/main/main.yml*) and variables of the customization tasks (see other files in
*default/main*).

.. seealso::
   * `Ansible variable precedence: Where should I put a variable?
     <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_

.. _ug_vars_defaults:
.. include:: vars-defaults.rst


.. _ug_bp:

*************
Best practice
*************

* Create a playbook and test the syntax ::

   shell> ansible-playbook playbook.yml --syntax-check

* See what variables will be included ::

   shell> ansible-playbook playbook.yml -t cimage_debug \
                                        -e cimage_debug=true \
					-e cimage_debug_classified=true

* Download images. To make the task idempotent use the attribute *checksum* in the items of the list *cimage_download*. See :ref:`ug_vars_defaults` ::

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

    shell> dd image.img of=/dev/mmcsd0 bs=1m conv=sync status=progress

* Keep the image mounted if you want to run the playbook periodically. In this case, repeated
  execution of the playbook should be idempotent ::

    shell> ansible-playbook playbook.yml -e cimage_umount=false

  However, the mountpoint is not configured in */etc/fstab* and won't survive a reboot. If this is
  a problem put the configuration of the memory disk into */etc/rc.conf* and configure the
  mountpoint in */etc/fstab*.

.. _ug_examples:

********
Examples
********

.. toctree::
   :name: examples_toc

   example-wifi-basic-cl
   example-wpacli-cl
   example-003

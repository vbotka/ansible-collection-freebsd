.. _ug_installation:

Installation
************

The most convenient way to install an Ansible role is to use `Ansible Galaxy`_
CLI ``ansible-galaxy``. The utility comes with the standard Ansible package and
provides a simple interface to the Ansible Galaxy's services. For example, take
a look at the current status of the role ::

    shell> ansible-galaxy role info vbotka.config_light

and install it ::

    shell> ansible-galaxy role install vbotka.config_light

Install the collections `community.general`_, `ansible.posix`_ and `vbotka.freebsd`_ if necessary ::

    shell> ansible-galaxy collection install ansible.posix
    shell> ansible-galaxy collection install community.general
    shell> ansible-galaxy collection install vbotka.freebsd

Install ``yamllint`` to use the default validation of the created handlers and
assembled data. See the variables **cl_assemble_validate** and
**cl_handlers_validate** in **defaults/main.yml**. Optionally, install and
configure ``ansible-lint``.

.. note::

   * By default, sanity checking of ``yamllint`` is disabled ``cl_sanity_yamllint=false``

.. hint::

   * To install specific versions from various sources see `Ansible Galaxy`_.

   * Look at other roles ::

       shell> ansible-galaxy search --author=vbotka


.. _ansible.posix: https://github.com/ansible-collections/ansible.posix/
.. _community.general: https://github.com/ansible-collections/community.general/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _Ansible Galaxy: <https://galaxy.ansible.com/ui/

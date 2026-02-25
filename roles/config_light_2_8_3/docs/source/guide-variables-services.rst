.. _ug_variables_services:

Services
========

.. contents::
   :local:

Synopsis
^^^^^^^^

The dictionary ``cl_services`` comprises managed services.

Parameters
^^^^^^^^^^

+---------------------+-----------------------+---------------------------------------+
| Parameter           | Type                  | Comments                              |
+=====================+=======================+=======================================+
| name                | string ``required``   | Name of the service.                  |
+---------------------+-----------------------+---------------------------------------+
| state               | string                | State of the service.                 |
|                     |                       | default: started (Linux)              |
|                     |                       | default: start   (FreeBSD)            |
+---------------------+-----------------------+---------------------------------------+
| enabled             | boolean               | Start on boot.                        |
|                     |                       | default: true                         |
+---------------------+-----------------------+---------------------------------------+

.. seealso::

   * The tasks :ref:`as_services.yml`
   * The Ansible module `ansible.builtin.service`_
   * The Ansible module `vbotka.freebsd.service`_

.. note::

   Depending on the OS, see the Ansible modules ``*.service`` what values are allowed.

FreeBSD
^^^^^^^

rc.conf
"""""""

In FreeBSD, the services are configured in ``/etc/rc.conf`` by default ::

  cl_rcconfd: false

If you want to use ``/etc/rc.conf.d`` set ::

  cl_rcconfd: true

By default, the parameter ``name`` is used as the filename ::

  cl_rcconfd_path:
    default: "{{ cl_rcconfd_dir }}/{{ _service }}"

where ::

  _service: "{{ item.value.name }}"


rcvar
"""""

By default, the parameter ``name`` is used to create a ``rcvar`` ::

  cl_rcconf_rcvar:
    default: "{{ _service }}_enable"
    devfs: devfs_load_rulesets

.. seealso::

   * The tasks :ref:`as_services.yml`
   * The role defaults ``defaults/main.yml``


Examples
^^^^^^^^

FreeBSD services for Postfix and Sendmail
"""""""""""""""""""""""""""""""""""""""""

[`contrib/postfix/conf-light/service.d/postfix.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/postfix/conf-light/services.d/postfixd.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/postfix/conf-light/services.d/postfix.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:

[`contrib/postfix/conf-light/service.d/sendmail.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/postfix/conf-light/services.d/sendmail.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/postfix/conf-light/services.d/sendmail.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:

.. seealso::

   * :ref:`as_vars-services.yml`
   * :ref:`as_services.yml`


.. _ansible.builtin.service: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
.. _vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/

.. _ug_tasks_wpasupconf:

Configure /etc/wpa_supplicant.conf
==================================

Customize the variables to your needs.

.. literalinclude:: ../../defaults/main/wpasupconf.yml
    :caption: `defaults/main/wpasupconf.yml`_
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. seealso::

   * Source code :ref:`as_wpasupconf.yml`
   * `Ansible variable precedence. Where should I put a variable?`_

.. warning::

   * Don't make any changes in the files in the directory ``defaults/main``. The role update will
     overwrite the changes.

.. _Ansible variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
.. _defaults/main/wpasupconf.yml: https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/wpasupconf.yml

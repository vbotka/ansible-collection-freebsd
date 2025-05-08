.. _ug_tasks_wpasupconf:

Configure /etc/wpa_supplicant.conf
==================================

Customize the variables to your needs.

[`defaults/main/wpasupconf.yml <https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/wpasupconf.yml>`_]

.. literalinclude:: ../../defaults/main/wpasupconf.yml
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. seealso::

   * Source code :ref:`as_wpasupconf.yml`
   * `Ansible variable precedence: Where should I put a variable?
     <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_

.. warning::

   * Don't make any changes to the files in *defaults/main*. The changes will be overwritten by the
     update of the role. Customize the default values in the files in *vars/main*.

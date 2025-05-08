.. _ug_tasks_rcconf:

Configure /etc/rc.conf
======================

Customize the variables to your needs.

[`defaults/main/rcconf.yml <https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/rcconf.yml>`_]

.. literalinclude:: ../../defaults/main/rcconf.yml
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. seealso::

   * Source code :ref:`as_rcconf.yml`
   * `Ansible variable precedence: Where should I put a variable?
     <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_

.. warning::

   * Don't make any changes to the files in *defaults/main*. The changes will be overwritten by the
     update of the role. Customize the default values in the files in *vars/main*.

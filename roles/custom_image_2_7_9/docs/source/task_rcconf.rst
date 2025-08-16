.. _ug_tasks_rcconf:

Configure /etc/rc.conf
======================

Customize the variables to your needs.

.. literalinclude:: ../../defaults/main/rcconf.yml
    :caption: `defaults/main/rcconf.yml`_
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. seealso::

   * Source code :ref:`as_rcconf.yml`
   * `Ansible variable precedence. Where should I put a variable?`_

.. warning::

   * Don't make any changes in the files in the directory ``defaults/main``. The role update will
     overwrite the changes.

.. _Ansible variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
.. _defaults/main/rcconf.yml: https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/rcconf.yml

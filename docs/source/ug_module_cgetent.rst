.. _ug_module_cgetent:

.. index::
   single: module vbotka.freebsd.cgetent; Module cgetent
   single: vbotka.freebsd.cgetent; Module cgetent
   single: cgetent; Module cgetent

Module vbotka.freebsd.cgetent
-----------------------------

Runs capability database queries on BSD systems against files like
``/etc/login.conf``, ``/etc/printcap``, or ``/etc/termcap``.  Similar to the
`ansible.builtin.getent`_ module, results are registered in the
``ansible_facts`` namespace.

.. hint::

   View the documentation from the command line:

   .. code:: console

      (env) > ansible-doc -t module vbotka.freebsd.cgetent

.. seealso::

   * man `getcap(3)`_
   * Ansible Galaxy `Module vbotka.freebsd.cgetent`_

.. _ug_debug:

Debug
*****

To see additional information enable debug output in the configuration ::

    cl_debug: true

, or set the extra variable in the command: ::

    shell> ansible-playbook pb.yml -e cl_debug=true

.. note::

   The debug output of this role is optimized for ``result_format=yaml``. See
   `result_format`_. Set it in the configuration

   .. code:: ini

      [defaults]
      callback_result_format = yaml

   or in the environment

   .. code:: bash

      ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

.. seealso::

   * `Playbook Debugger`_
   * `Debugging modules`_
   * `Python Debugging With Pdb`_


.. _Playbook Debugger: https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html
.. _Debugging modules: https://docs.ansible.com/ansible/latest/dev_guide/debugging.html#debugging-modules
.. _Python Debugging With Pdb: https://realpython.com/python-debugging-pdb
.. _result_format: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-result_format

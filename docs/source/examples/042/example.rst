.. _example_042:

042 Filters dict_to_ast and ast_to_nginx
----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: filter vbotka.freebsd.dict_to_ast; Example 042
.. index:: single: vbotka.freebsd.dict_to_ast; Example 042
.. index:: single: dict_to_ast; Example 042
.. index:: single: filter vbotka.freebsd.ast_to_nginx; Example 042
.. index:: single: vbotka.freebsd.ast_to_nginx; Example 042
.. index:: single: ast_to_nginx; Example 042

Use case
^^^^^^^^

Use the :ref:`filter vbotka.freebsd.dict_to_ast <ug_filter_dict_to_ast>`
and the :ref:`filter vbotka.freebsd.ast_to_nginx <ug_filter_ast_to_nginx>`
to create an NGINX configuration.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── pb-test-ast.yml
  └── pb-test-nginx.yml

Synopsis
^^^^^^^^

* In the playbook ``pb-test-ast.yml``, use the :ref:`filter
  vbotka.freebsd.dict_to_ast <ug_filter_dict_to_ast>` to convert a YAML
  dictionary into a crossplane-compatible AST (Abstract Syntax Tree) list for
  NGINX configuration generation.

* In the playbook ``pb-test-nginx.yml``, use the :ref:`filter
  vbotka.freebsd.ast_to_nginx <ug_filter_ast_to_nginx>` to convert a crossplane
  AST (Abstract Syntax Tree) list into an NGINX configuration.

Requirements
^^^^^^^^^^^^

* :ref:`ug_filter_dict_to_ast`
* :ref:`ug_filter_ast_to_nginx`

Notes
^^^^^

The filter ``ast_to_nginx`` requires the Python `package crossplane`_.

.. seealso::

   * Example :ref:`example_527`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Playbook pb-test-ast.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-ast.yml
   :language: yaml+jinja
   :emphasize-lines: 7-17

Playbook output - Test filter dict_to_ast
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-ast.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :emphasize-lines: 6-30

Playbook pb-test-nginx.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-nginx.yml
   :language: yaml+jinja
   :emphasize-lines: 7-17

Playbook output - Test filter ast_to_nginx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-nginx.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :emphasize-lines: 6-19
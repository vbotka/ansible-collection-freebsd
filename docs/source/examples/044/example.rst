.. _example_044:

044 Filter ast_to_haproxy
-------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: HAProxy; Example 044
   single: filter vbotka.freebsd.ast_to_haproxy; Example 044
   single: vbotka.freebsd.ast_to_haproxy; Example 044
   single: ast_to_haproxy; Example 044
   single: filter vbotka.freebsd.to_ast; Example 044
   single: vbotka.freebsd.to_ast; Example 044
   single: to_ast; Example 044

Use case
^^^^^^^^

Use the :ref:`filter vbotka.freebsd.ast_to_haproxy <ug_filter_ast_to_haproxy>`
to create an `HAProxy`_ configuration.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── pb-ast-to-haproxy.yml
  ├── pb-to-ast.yml
  └── vars
      └── haproxy_conf.yml

Synopsis
^^^^^^^^

In the playbook ``pb-ast-to-haproxy.yml``, use the :ref:`filter
vbotka.freebsd.ast_to_haproxy <ug_filter_ast_to_haproxy>` to convert an AST
(Abstract Syntax Tree) list into an HAProxy configuration.

Requirements
^^^^^^^^^^^^

* :ref:`ug_filter_ast_to_haproxy`
* :ref:`ug_filter_to_ast`

Notes
^^^^^

TBD

.. seealso::

   * `HAProxy`_ The Reliable, High Performance TCP/HTTP Load Balancer

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

vars
^^^^

.. literalinclude:: vars/haproxy_conf.yml
   :language: yaml

Playbook pb-to-ast.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-to-ast.yml
   :language: yaml+jinja

Playbook output - Test filter to_ast
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-to-ast.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

Playbook pb-ast-to-haproxy.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-ast-to-haproxy.yml
   :language: yaml+jinja

Playbook output - Test filter ast_to_haproxy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-ast-to-haproxy.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :emphasize-lines: 6-39
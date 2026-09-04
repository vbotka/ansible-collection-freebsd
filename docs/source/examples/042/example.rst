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

Use filter `vbotka.freebsd.dict_to_ast`_ and filter
`vbotka.freebsd.ast_to_nginx`_ to create Nginx configuration.

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

* In the playbook ``pb-test-ast.yml`` use the filter
  `vbotka.freebsd.dict_to_ast`_ to convert YAML dictionary into a
  crossplane-compatible AST (Abstract Syntax Tree) list for NGINX configuration
  generation.

* In the playbook ``pb-test-nginx.yml`` use the filter
  `vbotka.freebsd.ast_to_nginx`_ to convert crossplane AST (Abstract Syntax
  Tree) list into NGINX config.

Requirements
^^^^^^^^^^^^

* filter `vbotka.freebsd.dict_to_ast`_
* filter `vbotka.freebsd.ast_to_nginx`_

Notes
^^^^^

The filter ``ast_to_nginx`` requires `package crossplane`_.

.. seealso::

   Example :ref:`example_527`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Playbook pb-test-ast.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-ast.yml
   :language: yaml
   :emphasize-lines: 7-17

Playbook output - Test filter dict_to_ast
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-ast.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :emphasize-lines: 6-30

Playbook pb-test-nginx.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-nginx.yml
   :language: yaml
   :emphasize-lines: 7-17

Playbook output - Test filter ast_to_nginx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-nginx.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :emphasize-lines: 6-19


.. _vbotka.freebsd.dict_to_ast: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/dict_to_ast/
.. _vbotka.freebsd.ast_to_nginx: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/ast_to_nginx/
.. _package crossplane: https://pypi.org/project/crossplane/

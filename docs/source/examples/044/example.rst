.. _example_044:

044 Filter ast_to_haproxy
-------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: filter vbotka.freebsd.ast_to_haproxy; Example 044
.. index:: single: vbotka.freebsd.ast_to_haproxy; Example 044
.. index:: single: ast_to_haproxy; Example 044
.. index:: single: filter vbotka.freebsd.dict_to_ast; Example 044
.. index:: single: vbotka.freebsd.dict_to_ast; Example 044
.. index:: single: dict_to_ast; Example 044

Use case
^^^^^^^^

Use the filter `vbotka.freebsd.ast_to_haproxy`_ to create an HAProxy
configuration.

Tree
^^^^

.. code-block:: console

   shell> tree .
   .
   ├── ansible.cfg
   ├── pb-ast-to-haproxy.yml
   └── vars
       └── haproxy_conf.yml

Synopsis
^^^^^^^^

In the playbook ``pb-ast-to-haproxy.yml``, use the filter
`vbotka.freebsd.ast_to_haproxy`_ to convert an AST (Abstract Syntax
Tree) list into an HAProxy configuration.

Requirements
^^^^^^^^^^^^

* Filter `vbotka.freebsd.ast_to_haproxy`_
* Filter `vbotka.freebsd.dict_to_ast`_

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

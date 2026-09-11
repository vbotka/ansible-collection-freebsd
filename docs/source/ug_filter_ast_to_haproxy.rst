.. _ug_filter_ast_to_haproxy:

.. index:: single: filter vbotka.freebsd.ast_to_haproxy; Plugins
.. index:: single: ast_to_haproxy; Plugins

Filter vbotka.freebsd.ast_to_haproxy
------------------------------------

.. contents::
   :local:
   :depth: 2

Synopsis
^^^^^^^^

The ``ast_to_haproxy`` filter translates an Abstract Syntax Tree (AST)
structure into native `HAProxy`_ configuration syntax
(``haproxy.cfg``). It is typically used in conjunction with
``dict_to_ast`` to generate configuration files from high-level YAML
representations without relying on complex Jinja2 templates.


Parameters
^^^^^^^^^^

.. list-table::
   :widths: 20 15 15 50
   :header-rows: 1

   * - Parameter
     - Type
     - Default
     - Comments
   * - **_input**
     - sequence / mapping
     -
     - AST structure emitted by ``dict_to_ast`` or custom AST builders.
   * - **indent**
     - integer
     - ``4``
     - Number of spaces used for directive indentation inside sections.


Grammar & Transformations
^^^^^^^^^^^^^^^^^^^^^^^^^

The filter applies several domain-specific normalizations to
accommodate structured data trees:

Section Containers

   Plural section dictionaries (``frontends``, ``backends``,
   ``listens``) are unwrapped into individual, singular top-level
   sections (``frontend <name>``, ``backend <name>``, ``listen
   <name>``).

Directives & Sub-groups

   * **Options & Timeouts:** Directives nested under ``options`` or
     ``timeouts`` maps are flattened to individual ``option <name>``
     and ``timeout <name> <val>`` lines.

   * **ACLs:** Rules nested under ``acls`` are converted to ``acl
     <name> <criterion> <values...>``.

   * **Servers:** Server records are inlined to standard ``server
     <name> <address> [check] [options]`` lines.

   * **Routing:** ``use_backends`` lists are rendered into single-line
     ``use_backend <backend> <condition>`` directives.

Boolean Normalization

   Boolean parameters (``True``) are rendered as bare flags (e.g.,
   ``daemon``, ``httplog``, ``check``). Directives mapped to ``False``
   or ``None`` are excluded from the output.


Examples
^^^^^^^^

Input Structured Data
"""""""""""""""""""""

.. code-block:: yaml

    haproxy_config_data:
      global:
        log: /var/run/log local0
        maxconn: 4096
        user: nobody
        group: nobody
        daemon: true
      defaults:
        log: global
        mode: http
        retries: 3
        options:
          httplog: true
          dontlognull: true
        timeouts:
          connect: 5s
          client: 30s
          server: 30s
      frontends:
        http_front:
          bind: "*:80"
          acls:
            is_api: path_beg /api
          use_backends:
            - backend: api_servers
              condition: if is_api
          default_backend: web_servers
      backends:
        web_servers:
          balance: roundrobin
          servers:
            web1:
              address: 10.0.1.10:8080
              check: true
        api_servers:
          balance: roundrobin
          servers:
            api1:
              address: 10.0.2.10:8080
              check: true

Ansible Task Pipeline
"""""""""""""""""""""

.. code-block:: yaml

    - name: Generate HAProxy configuration
      ansible.builtin.copy:
        dest: /usr/local/etc/haproxy.conf
        content: |
          {{ haproxy_config_data
             | vbotka.freebsd.dict_to_ast
             | vbotka.freebsd.ast_to_haproxy }}
        mode: '0644'
        validate: haproxy -c -f %s

Generated Configuration Output
""""""""""""""""""""""""""""""

.. code-block:: text

    global
        log /var/run/log local0
        maxconn 4096
        user nobody
        group nobody
        daemon

    defaults
        log global
        mode http
        retries 3
        option httplog
        option dontlognull
        timeout connect 5s
        timeout client 30s
        timeout server 30s

    frontend http_front
        bind *:80
        acl is_api path_beg /api
        use_backend api_servers if is_api
        default_backend web_servers

    backend web_servers
        balance roundrobin
        server web1 10.0.1.10:8080 check

    backend api_servers
        balance roundrobin
        server api1 10.0.2.10:8080 check

Return Value
^^^^^^^^^^^^

.. list-table::
   :widths: 20 15 65
   :header-rows: 1

   * - Key
     - Type
     - Description
   * - **_value**
     - string
     - The formatted HAProxy configuration string.

.. note::

   * See Ansible Galaxy :ref:`ug_filter_ast_to_haproxy`

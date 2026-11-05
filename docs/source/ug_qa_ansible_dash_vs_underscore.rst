.. _ug_qa_ansible_dash_vs_underscore:

Should I use dashes or underscores in hostnames, group names, and variable names?
---------------------------------------------------------------------------------

In Ansible, underscores (``_``) are generally preferred over dashes (``-``) for
host names, group names, and variable names. While both characters may appear
to work in basic inventory setups, using hyphens in variable names or host/group
identifiers frequently causes Jinja2 parsing errors, as the hyphen is interpreted
as a subtraction operator.

Ansible variables must adhere to standard Python identifier rules, meaning hyphens
are invalid in variable names. For group and inventory host names, hyphens can introduce
parsing ambiguities in playbooks and conditional statements (e.g., dot-notation access
like ``hostvars[inventory_hostname].web-server`` fails).

.. list-table:: Comparison: Underscore vs Dash
   :widths: 25 35 40
   :header-rows: 1

   * - Feature
     - Underscore (``_``)
     - Dash (``-``)
   * - Example
     - ``www_01``
     - ``www-01``
   * - Ansible Recommendation
     - Recommended practice
     - Discouraged
   * - Jinja2 & Variable Syntax
     - Safe; evaluates as a valid Python/Jinja2 identifier.
     - Invalid in variable names; parsed as a subtraction operator (``-``).
   * - DNS Standard Compliance
     - Does not adhere to RFC 1123 (if used directly as an FQDN).
     - Adheres to RFC 1123 DNS hostname standards.

Best Practice
^^^^^^^^^^^^^

If your network requires RFC 1123 compliance, use underscores (e.g., ``www_01``)
for Ansible inventory host aliases, groups, and variables, while keeping your
actual DNS infrastructure named with dashes (e.g., ``www-01.example.com``). In
the inventory configuration, map the Ansible alias to the DNS host name using
the ``ansible_host`` variable:

.. code-block:: ini

   [web_servers]
   www_01 ansible_host=www-01.example.com
   www_02 ansible_host=www-02.example.com

.. seealso::

   * `ansible-lint var-naming`_
   * `Creating valid variable names`_
   * `RFC 1035`_ (Domain Implementation and Specification)
   * `RFC 1123`_ (Requirements for Internet Hosts - Application and Support)

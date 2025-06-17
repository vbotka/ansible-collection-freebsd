.. _example_500:

500 Syslog server
-----------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: syslog server; Example 500

Use case
^^^^^^^^

Create and run a syslog server. Create syslog clients and test them.

.. hint::

   Prepare the jails. For example:

   * Destroy all jails and templates in :ref:`example_202`

     .. code-block:: console

        (env) > ansible-playbook -i iocage-hosts.ini vbotka.freebsd.pb_iocage_destroy_all_jails.yml

   * Create *ansible_client* templates in :ref:`example_202`

     .. code-block:: console

        (env) > ansible-playbook -i iocage-hosts.ini vbotka.freebsd.pb_iocage_template.yml

   * Create jails in :ref:`example_207`

     .. code-block:: console

        (env) > ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-create.yml


WIP.

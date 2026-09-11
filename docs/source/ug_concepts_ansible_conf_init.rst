.. _ug_concepts_ansible_conf_init:

Repository ansible-conf-init
----------------------------

.. index:: single: ansible-conf-init; Repository ansible-conf-init
.. index:: single: pb-init.yml; Repository ansible-conf-init
.. index:: single: ai_db_host; Repository ansible-conf-init
.. index:: single: ai_db_class; Repository ansible-conf-init

.. contents::
   :local:
   :depth: 2

Overview
^^^^^^^^

The `ansible-conf-init`_ repository provides the first-stage Ansible
configuration and playbook required by the ``ansible_init`` service to
bootstrap remote hosts and jails.

Designed for pull-based initialization workflows (``ansible-pull``)
and automated provisioning pipelines (such as FreeBSD jails, VM
templates, or bare-metal node bring-up), this repository acts as the
initial control repository that a target machine clones and executes
upon first boot.

Playbook pb-init.yml workflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: figures/pb-init.svg
   :alt: Playbook pb-init.yml Workflow
   :scale: 120
   :align: center
   :width: 80%

|

Host and Class Discovery
""""""""""""""""""""""""

The playbook ``pb-init.yml`` runs the ``hostname`` command and
registers the standard output to determine the host identity
(``ai_hostname``). It gathers custom local facts (``ansible_local``)
to discover any FreeBSD iocage jail classes assigned to the system
(``ansible_local.iocage.class``) that match configured database
classes (``ai_db_class``).

Variables
"""""""""

The playbook iterates through the directory defined by ``ai_vars`` and
dynamically loads all ``.yml`` and ``.yaml`` variable files
(populating dictionaries such as ``ai_db_host`` and
``ai_db_class``). It then outputs debug information displaying the
current execution parameters, resolved host, detected classes, and
project settings.

Configuration Validation and Early Exit
"""""""""""""""""""""""""""""""""""""""

The playbook checks whether the current host exists in ``ai_db_host``
or if any matching classes were found in ``ai_db_class``. If neither
condition is met, it prints a warning message and terminates execution
early using ``ansible.builtin.meta: end_play``.

Host-Specific Execution Path
""""""""""""""""""""""""""""

Runs when ``ai_hostname`` is found directly in ``ai_db_host``. It
constructs an ``ansible-pull`` command using the target host's
specific repository URL, destination directory, playbook name, and
variable flags, then executes the generated command by importing
``tasks/execute-cmd.yml``.

Class-Specific Execution Path
"""""""""""""""""""""""""""""

Runs when one or more valid classes are defined in ``ai_db_class``. It
loops through each matched class to build a chained, multi-stage
``ansible-pull`` command sequence, then executes the chained commands
by importing ``tasks/execute-cmd.yml``.

.. seealso::

   * Repository `ansible-conf-init`_
   * Repository `ansible-conf-test`_
   * Example :ref:`example_524`
   * Example :ref:`example_525`

Best Practices
^^^^^^^^^^^^^^

* **Fork the Repository:** Fork `ansible-conf-init`_ into your
  organization's version control system to lock down dependencies,
  specify internal collections, and manage custom SSH keys and
  certificates.

* **Secure Credentials with Ansible Vault:** Never store plaintext
  secrets (such as root passwords or private keys) in public or shared
  pull repositories. Use ``ansible-vault`` with vault password files
  or secure key-management integrations.

* **Ensure Task Idempotency:** Verify that all tasks inside the
  repository are strictly idempotent so repeated runs via
  ``ansible-pull`` or ``ansible_init`` do not disrupt running
  services.

* **Use Local Connection Strategy:** Confirm that
  ``ansible_connection: local`` is configured in your inventory to
  eliminate SSH self-connection overhead during local bootstrapping.

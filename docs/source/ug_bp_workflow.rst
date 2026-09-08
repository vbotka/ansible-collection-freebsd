.. _ug_bp_workflow:

Workflow
--------

A standard automation workflow balances native module tasks with role runner
tasks to handle operations from base provisioning to jail orchestration.

First, fetch the required FreeBSD release(s) and create basejail templates using
either the ``iocage`` module or role runner tasks. Build out the required
templates (via runners, roles, or modules), then clone and start the target
jails.

Once the jails are running, generate an inventory—either dynamically using the
``iocage`` or ``iocage2`` inventory plugins, or by combining file/stat checks
with ``ansible.builtin.add_host``.

With the inventory established, manage the jails directly using standard Ansible
playbooks. Because the ``iocage`` CLI is inherently complex and a single module
cannot efficiently cover every edge case, use runner tasks from the ``iocage``
role for advanced operations, or fall back to the ``ansible.builtin.command``
module for non-idempotent actions (such as batch provisioning with ``--count``).
.. _ug_bp_workflow:

Workflow
--------

A standard automation workflow balances native ``module`` tasks with ``runner``
scripts to handle operations from base provisioning to jail orchestration.

First, ``fetch`` the required FreeBSD release(s) and ``create`` basejail
templates using either the ``iocage`` module or ``runner`` tasks. Build out the
required ``templates`` (via runner, roles or modules), then ``clone`` and
``start`` the target jails.

Once the jails are running, generate a ``dynamic inventory``—either using stat
combined with ``ansible.builtin.add_host`` or by querying the inventory plugins
``iocage`` or ``iocage2``.

With the inventory established, manage the jails directly using standard Ansible
playbooks. Because the ``iocage`` binary is inherently complex and the
``module`` cannot efficiently cover every edge case, use ``runner`` tasks from
the ``iocage`` role for advanced operations, or fall back to the
``ansible.builtin.command`` module for non-idempotent actions (such as batch
provisioning with ``--count``).

.. _ug_best_practice:

Best Practice
*************

.. topic:: Binary Complexity vs. Module Coverage

   The iocage CLI contains an extensive
   set of subcommands and options. Attempting to support all features natively
   within the iocage Ansible module is inefficient to maintain, so the module
   focuses on core, everyday operations.

.. topic:: Role Runner Tasks for Extended Features

   For specialized workflows or edge
   cases not covered directly by the module, use the runner tasks provided in the
   iocage role.

.. topic:: Handling Non-Idempotent Commands

   For non-idempotent operations or CLI flags
   that bypass standard declarative state management (such as provisioning
   multiple instances with --count), execute the command directly using
   ansible.builtin.command.

.. toctree::
   :maxdepth: 1

   ug_bp_installation
   ug_bp_workflow
   ug_bp_usecases
   ug_bp_iocage
   ug_bp_references

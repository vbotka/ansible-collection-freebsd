.. _ug_best_practice:

Best Practice
*************

.. contents::
   :local:
   :depth: 1

Topics:

* The *iocage* binary is very complex.

* The *iocage* module can't cover all use-cases. The maintenance of such complexity wouldn't be efficient.

* For use cases not covered by the module, use the *runner* tasks from the role *iocage*. Use the
  module *command* if not idempotent. For example, if using the option *--count*.

.. _ug_bp_installation:
.. include:: ug_bp_installation.rst

.. _ug_bp_workflow:
.. include:: ug_bp_workflow.rst

.. _ug_bp_usecases:
.. include:: ug_bp_usecases.rst

.. _ug_bp_iocage:
.. include:: ug_bp_iocage.rst

.. _ug_bp_iocage_tags:
.. include:: ug_bp_iocage_tags.rst

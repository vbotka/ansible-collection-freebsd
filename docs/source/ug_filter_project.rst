.. _ug_filter_project:

.. index:: single: filter vbotka.freebsd.project; Filter project
.. index:: single: project; Filter project
.. index:: single: vmm; Filter project
.. index:: single: class; Filter project

Filter vbotka.freebsd.project
-----------------------------

The ``project`` filter restructures a dictionary of jails and their
hosts defined with ``vmm`` and ``class`` attributes.  Groups full
service specifications under their respective target hypervisor
(``vmm``).  Inverts the ``class`` attribute into a reverse-lookup
dictionary mapping class names to lists of service names.

.. hint::

   View the documentation from the command line:

   .. code:: console

      shell> ansible-doc -t filter vbotka.freebsd.project

.. seealso::

   * Ansible Galaxy `filter project`_

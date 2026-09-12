.. _ug_filter_project:

.. index:: single: filter vbotka.freebsd.project; Plugins
.. index:: single: project; Plugins

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

.. note::

   * See Ansible Galaxy `filter project`_

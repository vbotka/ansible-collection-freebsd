.. _ug_filter_project:

.. index:: single: filter vbotka.freebsd.project; Plugins
.. index:: single: project; Plugins

Filter vbotka.freebsd.project
-----------------------------

The `filter vbotka.freebsd.project`_ restructures a dictionary of jails and their
hosts defined with ``vmm`` and ``class`` attributes.  Groups full service
specifications under their respective target hypervisor (``vmm``).  Inverts the
``class`` attribute into a reverse-lookup dictionary mapping class names to
lists of service names.

.. note::

   * See Ansible Galaxy `filter vbotka.freebsd.project`_


.. _filter vbotka.freebsd.project: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/project/

.. _example_041:

041 Filter project
------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: filter vbotka.freebsd.project; Example 041
.. index:: single: vbotka.freebsd.project; Example 041
.. index:: single: project; Example 041

Use case
^^^^^^^^

Use the `filter vbotka.freebsd.project`_ to restructure a project dictionary.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  └── pb.yml

Synopsis
^^^^^^^^

Restructure a dictionary of jails and their hosts defined with ``vmm`` and
``class`` attributes.

  * Groups full service specifications under their respective host (``vmm``).

  * Inverts the ``class`` attribute into a reverse-lookup dictionary mapping class
    names to lists of ``jails``.

Requirements
^^^^^^^^^^^^

* `filter vbotka.freebsd.project`_

Notes
^^^^^

TBD

.. seealso::

   * :ref:`ug_concepts_project`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Test filter project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml


.. _filter vbotka.freebsd.project: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/project/

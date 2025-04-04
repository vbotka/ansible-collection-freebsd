.. _as_tasks:

Tasks
=====

.. _as_main.yml:

main.yml
--------

Synopsis: Main task.


Import tasks if enabled.


[`tasks/main.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/main.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/main.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_setup.yml:

setup.yml
---------

Synopsis: Configure setup.


Description of the task.


[`tasks/setup.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/setup.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/setup.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars-handlers.yml:

vars-handlers.yml
-----------------

Synopsis: Configure vars-handlers.


Description of the task.


[`tasks/vars-handlers.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/vars-handlers.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars-handlers.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars.yml:

vars.yml
--------

Synopsis: Configure vars.


Description of the task.


[`tasks/vars.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/vars.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars-packages.yml:

vars-packages.yml
-----------------

Synopsis: Configure vars-packages.


Description of the task.


[`tasks/vars-packages.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/vars-packages.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars-packages.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars-states.yml:

vars-states.yml
---------------

Synopsis: Configure vars-states.


Description of the task.


[`tasks/vars-states.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/vars-states.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars-states.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars-services.yml:

vars-services.yml
-----------------

Synopsis: Configure vars-services.


Description of the task.


[`tasks/vars-services.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/vars-services.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars-services.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars-files.yml:

vars-files.yml
--------------

Synopsis: Configure vars-files.


Description of the task.


[`tasks/vars-files.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/vars-files.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars-files.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_sanity.yml:

sanity.yml
----------

Synopsis: Configure sanity.


Description of the task.


[`tasks/sanity.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/sanity.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/sanity.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_debug.yml:

debug.yml
---------

Synopsis: Configure debug.


Description of the task.


[`tasks/debug.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/debug.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/debug.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_packages.yml:

packages.yml
------------

Synopsis: Configure packages.


Description of the task.


[`tasks/packages.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/packages.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/packages.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_states.yml:

states.yml
----------

Synopsis: Configure states.


Description of the task.


[`tasks/states.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/states.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/states.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files.yml:

files.yml
---------

Synopsis: Manage files.


Iterate ``cl_files_order`` (6) and include tasks with particular modules.


[`tasks/files.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files.yml
    :language: Yaml
    :emphasize-lines: 3,6
    :linenos:

.. seealso::
   * See :ref:`ug_variables_files` *Order of options*


.. hint::
   * Customize the list ``cl_files_order`` and fit the order of the options to your needs.


.. _as_files-blockinfile.yml:

files-blockinfile.yml
---------------------

Synopsis: Configure files-blockinfile.


Description of the task.


[`tasks/files-blockinfile.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-blockinfile.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-blockinfile.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-copy.yml:

files-copy.yml
--------------

Synopsis: Configure files-copy.


Description of the task.


[`tasks/files-copy.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-copy.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-copy.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-create-backup.yml:

files-create-backup.yml
-----------------------

Synopsis: Configure files-create-backup.


Description of the task.


[`tasks/files-create-backup.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-create-backup.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-create-backup.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-delete-backup.yml:

files-delete-backup.yml
-----------------------

Synopsis: Configure files-delete-backup.


Description of the task.


[`tasks/files-delete-backup.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-delete-backup.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-delete-backup.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-inifile.yml:

files-inifile.yml
-----------------

Synopsis: Configure files-inifile.


Description of the task.


[`tasks/files-inifile.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-inifile.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-inifile.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-lineinfile.yml:

files-lineinfile.yml
--------------------

Synopsis: Configure files-lineinfile.


Description of the task.


[`tasks/files-lineinfile.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-lineinfile.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-lineinfile.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-markers.yml:

files-markers.yml
-----------------

Synopsis: Configure files-markers.


Description of the task.


[`tasks/files-markers.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-markers.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-markers.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_mark-block.yml:

mark-block.yml
--------------

Synopsis: Configure mark-block.


Description of the task.


[`tasks/fn/mark-block.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/fn/mark-block.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/fn/mark-block.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-patch.yml:

files-patch.yml
---------------

Synopsis: Configure files-patch.


Description of the task.


[`tasks/files-patch.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-patch.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-patch.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-template.yml:

files-template.yml
------------------

Synopsis: Configure files-template.


Description of the task.


[`tasks/files-template.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-template.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-template.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_files-ucl.yml:

files-ucl.yml
-------------

Synopsis: Configure files-ucl.


Description of the task.


[`tasks/files-ucl.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-ucl.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/files-ucl.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_services.yml:

services.yml
------------

Synopsis: Configure services.


Description of the task.


[`tasks/services.yml <https://github.com/vbotka/ansible-config-light/blob/master/tasks/services.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/services.yml
    :language: Yaml
    :emphasize-lines: 1,2
    :linenos:






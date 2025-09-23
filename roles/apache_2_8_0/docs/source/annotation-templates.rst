.. _as_tamplates:

Templates
=========

.. _as_template_directory-block.j2:

directory-block.j2
------------------

Synopsis: Configure directory-block


Description of the task.


[`templates/directory-block.j2 <https://github.com/vbotka/ansible-apache/blob/master/templates/directory-block.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/directory-block.j2
    :language: jinja
    :emphasize-lines: 1
    :linenos:





.. _as_template_section2.j2:

section2.j2
-----------

Synopsis: Configure section2


Description of the task.


[`templates/section2.j2 <https://github.com/vbotka/ansible-apache/blob/master/templates/section2.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/section2.j2
    :language: jinja
    :emphasize-lines: 1
    :linenos:





.. _as_template_vhost2.j2:

vhost2.j2
---------

Synopsis: Configure vhost2


Description of the task.


[`templates/vhost2.j2 <https://github.com/vbotka/ansible-apache/blob/master/templates/vhost2.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/vhost2.j2
    :language: jinja
    :emphasize-lines: 1
    :linenos:





.. _as_template_vhost.j2:

vhost.j2
--------

Synopsis: Create virtual servers.


Create both http and https servers (1,8). Optionally ``default(True)`` redirect permanent http to https (4).


[`templates/vhost.j2 <https://github.com/vbotka/ansible-apache/blob/master/templates/vhost.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/vhost.j2
    :language: jinja
    :emphasize-lines: 1,4,8
    :linenos:

.. seealso:: 
   * Variable :ref:`ug_apache_vhost`





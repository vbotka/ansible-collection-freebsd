Default variables
=================

Review the default variables in the directory ``defaults/main``. For example,

.. highlight:: yaml
    :linenothreshold: 5

.. literalinclude:: ../../defaults/main/main.yml
    :caption: `defaults/main/main.yml`_
    :language: yaml
    :emphasize-lines: 2
    :linenos:

.. literalinclude:: ../../defaults/main/images.yml
    :caption: `defaults/main/images.yml`_
    :language: yaml
    :emphasize-lines: 2-3
    :linenos:

.. literalinclude:: ../../defaults/main/customize.yml
    :caption: `defaults/main/customize.yml`_
    :language: yaml
    :emphasize-lines: 2
    :linenos:

.. hint::

   * Create custom tasks in the directory ``tasks/fn``.
   * Fit the dictionary ``cimage_customize`` to your needs. See :ref:`as_customize.yml`

.. seealso::

   * Other files in  ``defaults/main``
   * The examples of the customization ``vars/main.yml.sample``

.. warning::

   * Don't make any changes in the files in the directory defaults/main*. The role update will
     overwrite the changes.

   * The default value of *cimage_debug_classified* is *false**. Passwords will be displayed if this
     variable is enabled.

.. _defaults/main/main.yml: https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/main.yml
.. _defaults/main/images.yml: https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/images.yml
.. _defaults/main/customize.yml: https://github.com/vbotka/ansible-freebsd-custom-image/blob/master/defaults/main/customize.yml

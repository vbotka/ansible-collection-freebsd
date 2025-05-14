.. _as_tamplates:

Templates
=========

.. _as_template_loader.conf.j2:

loader.conf.j2
--------------

Synopsis: Configure loader.conf


Description of the task.


[`templates/loader.conf.j2 <https://github.com/__GITHUB_USERNAME__/__PROJECT__/blob/__BRANCH__/templates/loader.conf.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/loader.conf.j2
    :language: jinja
    :emphasize-lines: 1
    :linenos:





.. _as_template_wpa_supplicant.conf.j2:

wpa_supplicant.conf.j2
----------------------

Synopsis: Create wpa_supplicant.conf


The attribute *conf* is a list. For example,

.. code-block:: yaml

   cimage_wpasupconf_data:
     - dev: wlan0
       network:
         - conf:
             - { key: ssid, value: '"my_access_point"' }
             - { key: psk, value: '"my_password"' }
             - { key: disabled, value: 0 }


[`templates/wpa_supplicant.conf.j2 <https://github.com/__GITHUB_USERNAME__/__PROJECT__/blob/__BRANCH__/templates/wpa_supplicant.conf.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/wpa_supplicant.conf.j2
    :language: jinja
    :emphasize-lines: 1
    :linenos:


.. note::
   * Some values must be double-quoted.
   * See https://wiki.archlinux.org/title/wpa_supplicant



.. _as_template_wpa_supplicant.conf.2.j2:

wpa_supplicant.conf.2.j2
------------------------

Synopsis: Create wpa_supplicant.conf


The attribute *conf* is a dictionary. For example,

.. code-block:: yaml

   cimage_wpasupconf_data:
     - dev: wlan0
       network:
         - conf:
             ssid: '"my_access_point"'
             psk: '"my_password"'
             disabled: 0


[`templates/wpa_supplicant.conf.2.j2 <https://github.com/__GITHUB_USERNAME__/__PROJECT__/blob/__BRANCH__/templates/wpa_supplicant.conf.2.j2>`_]

.. highlight:: jinja
    :linenothreshold: 5
.. literalinclude:: ../../templates/wpa_supplicant.conf.2.j2
    :language: jinja
    :emphasize-lines: 1
    :linenos:


.. note::
   * Some values must be double-quoted.
   * See https://wiki.archlinux.org/title/wpa_supplicant




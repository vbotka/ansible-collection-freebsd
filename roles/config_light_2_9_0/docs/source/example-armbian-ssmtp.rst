.. _ex_armbian_ssmtp:

Armbian Simple SMTP
*******************

.. _ex_ssmtp_packages:

Packages
========

.. _ex_packagesd_ssmtp:

contrib/ssmtp/conf-light/packages.d/ssmtp.yml
---------------------------------------------

Synopsis: Install Simple SMTP.

Use package (3) to install sSMTP.

[`contrib/ssmtp/conf-light/packages.d/ssmtp.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ssmtp/conf-light/packages.d/ssmtp.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ssmtp/conf-light/packages.d/ssmtp.yml
    :language: Yaml
    :emphasize-lines: 3
    :linenos:

.. seealso:: See :ref:`as_packages.yml` how the Linux packages are installed.
.. _ex_ssmtp_files:

Files
=====

.. _ex_config_light_ssmtp_yml:

contrib/ssmtp/config-light-ssmtp.yml
------------------------------------

Synopsis: Custom variables for sSMTP.

Put the host-specific variables (7) into the ``host_vars``. Optionally other variables might be put into the ``group_vars``.

[`contrib/ssmtp/config-light-ssmtp.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ssmtp/config-light-ssmtp.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ssmtp/config-light-ssmtp.yml
    :language: Yaml
    :emphasize-lines: 7
    :linenos:

.. _ex_filesd_revaliases:

contrib/ssmtp/conf-light/files.d/revaliases.yml
-----------------------------------------------

Synopsis: Create file.

Create file (3) from the template (9).

[`contrib/ssmtp/conf-light/files.d/revaliases.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ssmtp/conf-light/files.d/revaliases.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ssmtp/conf-light/files.d/revaliases.yml
    :language: Yaml
    :emphasize-lines: 3,9
    :linenos:

.. seealso:: See template `revaliases.j2 <https://github.com/vbotka/ansible-config-light/blob/master/templates/revaliases.j2>`_. See how files are created from template :ref:`as_files-template.yml`.
.. _ex_filesd_ssmtp_conf:

contrib/ssmtp/conf-light/files.d/ssmtp-conf.yml
-----------------------------------------------

Synopsis: Create file.

Create file (3) from the template (9).

[`contrib/ssmtp/conf-light/files.d/ssmtp-conf.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ssmtp/conf-light/files.d/ssmtp-conf.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ssmtp/conf-light/files.d/ssmtp-conf.yml
    :language: Yaml
    :emphasize-lines: 3,9
    :linenos:

.. seealso:: See template `ssmtp.conf.j2 <https://github.com/vbotka/ansible-config-light/blob/master/templates/ssmtp.conf.j2>`_. See how files are created from template :ref:`as_files-template.yml`.

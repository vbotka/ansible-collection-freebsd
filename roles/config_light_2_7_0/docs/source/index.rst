#########################
Ansible role Config Light
#########################

**vbotka.config_light**

Role version 2.7.0

The role installs packages, creates and configures files and services. The
handlers are created from user provided configuration data. The control-flow
will be determined by the configuration data. The configuration data also
determine which Ansible modules will be used. This `data-driven programming`_
paradigm provides a flexible and robust framework to apply basic Ansible
modules:

* apt, dnf, snap, package, pkgng, portinstall
* mount, file
* template, copy, replace, patch, lineinfile, blockinfile, ini_file, ucl
* service

| This `role`_ and the documentation is work in progress.
| Feel free to `share your feedback and report issues`_.
| `Contributions are welcome`_.

| GitHub: `ansible-config-light`_
| Ansible Galaxy: `vbotka.config_light`_

| This role is licensed and distributed as a whole under
| **BSD 2-Clause "Simplified" License**
| SPDX-License-Identifier: `BSD-2-Clause`_


.. toctree::
   :maxdepth: 1
   :caption: Table of Contents

   qsg
   guide
   examples
   annotation
   collection-bsd
   copyright
   legalnotice


Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


.. _data-driven programming: https://en.wikipedia.org/wiki/Data-driven_programming
.. _role: https://galaxy.ansible.com/vbotka/config_light
.. _share your feedback and report issues: https://github.com/vbotka/ansible-config-light/issues
.. _Contributions are welcome: https://github.com/firstcontributions/first-contributions
.. _ansible-config-light: https://github.com/vbotka/ansible-config-light
.. _vbotka.config_light: https://galaxy.ansible.com/vbotka/config_light
.. _BSD-2-Clause: https://spdx.org/licenses/BSD-2-Clause.html

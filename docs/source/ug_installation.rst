    
.. _ug_installation:

Installation
************

Install the collection from Ansible Galaxy::

  shell> ansible-galaxy collection install vbotka.freebsd

Upgrade the collection if already installed::

  shell> ansible-galaxy collection install --upgrade vbotka.freebsd
  Starting galaxy collection install process
  Process install dependency map
  Starting collection install process
  'vbotka.freebsd:0.5.0' is already installed, skipping.
  'ansible.posix:2.0.0' is already installed, skipping.
  'community.general:10.2.0' is already installed, skipping.
  
.. seealso::

   `Installing collections`_

.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _FreeBSD Supported Production Releases: https://www.freebsd.org/releases
.. _ansible.posix: https://docs.ansible.com/ansible/latest/collections/ansible/posix
.. _community.general: https://docs.ansible.com/ansible/latest/collections/community/general
.. _Installing collections: https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html
.. _Managing BSD hosts with Ansible: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html

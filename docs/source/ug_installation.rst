    
.. _ug_installation:

Installation
************

Install the collection from Ansible Galaxy ::

  shell> ansible-galaxy collection install vbotka.freebsd

Upgrade the collection if already installed. For example, ::

  shell> ansible-galaxy collection install --upgrade vbotka.freebsd
  Starting galaxy collection install process
  Process install dependency map
  Starting collection install process
  'vbotka.freebsd:0.5.0' is already installed, skipping.
  'ansible.posix:2.0.0' is already installed, skipping.
  'community.general:10.2.0' is already installed, skipping.
  
.. seealso::

   `Installing collections`_

.. _Installing collections: https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html

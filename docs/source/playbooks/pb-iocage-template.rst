pb-iocage-template
------------------

.. contents:: Table of Contents
   :depth: 2

.. index:: single: playbook pb-iocage-template.yml; pb-iocage-template
.. index:: single: act_pkg; pb-iocage-template
.. index:: single: act_user; pb-iocage-template
.. index:: single: act_pk; pb-iocage-template
.. index:: single: act_sudo; pb-iocage-template
.. index:: single: act_rcconf; pb-iocage-template
.. index:: single: act_dhclient; pb-iocage-template

Synopsis
^^^^^^^^

This playbook creates templates from the dictionary *templates*. For example,

.. code-block:: yaml

  templates:
    ansible_client:
      release: 14.1-RELEASE
      properties:
        ip4_addr: 'em0|10.1.0.199/24'
      dhclient: "{{ act_dhclient | dict2items }}"

Variables
^^^^^^^^^

A few variables are required to configure a template for Ansible clients. The below values will
skip all configuration tasks

.. code-block:: yaml

  act_pkg: []
  act_user: ''
  act_pk: ''
  act_sudo: false
  act_rcconf: false
  act_dhclient: {}

act_pkg
^^^^^^^

Install a list of packages. The minimal list is below. Set the Python version to your needs

.. code-block:: yaml

  act_pkg:
    - security/sudo
    - lang/python311

Fit the list to your needs. Usually, you want to add *gtar* and other archivers. See the module
`ansible.builtin.unarchive`_. If you want to use the collection `community.crypto`_ add *py-openssl*

.. code-block:: yaml

  act_pkg:
    - lang/python311                                                                 
    - security/sudo                                                                  
    - archivers/gtar
    - security/py-openssl                                                            
      
.. seealso::

   * `Setting the Python interpreter`_
   * `Understanding privilege escalation`_

act_user
^^^^^^^^

.. code-block:: yaml

  act_user: admin

act_pk
^^^^^^

.. code-block:: yaml

  act_pk: pk_admins.txt

act_sudo
^^^^^^^^

.. code-block:: yaml

  act_sudo: true

act_rcconf
^^^^^^^^^^

.. code-block:: yaml

  act_rcconf: true

act_dhclient
^^^^^^^^^^^^

.. code-block:: yaml

  act_dhclient:
    dhclient-exit-hooks: |
      case "$reason" in
          "BOUND"|"REBIND"|"REBOOT"|"RENEW")
          echo $new_ip_address > /var/db/dhclient-hook.address.$interface
          ;;
      esac

Workflow
^^^^^^^^

The last tasks *template.yml* convert the jails to templates. If you start the play again the first
tasks *setup.yml* will end the play if all templates have already been created. If you want to
reconfigure already created template set *template=0* manually. For example,

.. code-block:: sh

  shell> iocage set template=0 ansible_client

Take a look at Index what examples are available.


.. _Setting the Python interpreter: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter
.. _Understanding privilege escalation: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html
.. _community.crypto: https://galaxy.ansible.com/ui/repo/published/community/crypto/
.. _ansible.builtin.unarchive: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html#notes

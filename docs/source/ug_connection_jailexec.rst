.. _ug_connection_jailexec:
.. index:: single: connection vbotka.freebsd.jailexec; Plugins

connection vbotka.freebsd.jailexec
----------------------------------

The ``connection plugin vbotka.freebsd.jailexec`` connects the jails without SSH. The utility
``jexec`` at the jail host is used to run the commands within the jails.


Dynamic inventory configuration example:

.. code-block:: yaml

   plugin: vbotka.freebsd.iocage2
   host: iocage_06
   user: admin
   sudo: true
   get_properties: true
   inventory_hostname_tag: alias

   compose:
     iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))
     iocage_classes: iocage_properties.notes | regex_findall('(?<=class=)[\w\-]+|(?<=,)[\w\-]+')
   # connection plugin vbotka.freebsd.jailexec
     ansible_connection: "'vbotka.freebsd.jailexec'"
     ansible_ssh_user: "'admin'"
     ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none')
     ansible_jail_name: iocage_jid
     ansible_jail_privilege_escalation: "'sudo'"
   # ansible options
     ansible_python_interpreter: "'auto_silent'"

   groups:
     log_servers: iocage_classes is contains('log-server')
     log_clients: iocage_classes is contains('log-client')

   keyed_groups:
     - prefix: state
       key: iocage_state
     - prefix: vmm
       key: iocage_tags.vmm


| ansible_ssh_user: User for SSH login to jail host
| ansible_jail_host: FreeBSD host that runs the jails
| ansible_jail_name: Name of the jail to connect to

.. seealso::
   * `man jexec`_


.. _man jexec: https://man.freebsd.org/cgi/man.cgi?query=jexec&sektion=8

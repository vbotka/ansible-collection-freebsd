.. _ug_bp_installation:

Installation
------------

Install and configure ``iocage`` using the tasks from the ``iocage role`` to
ensure a consistent host setup. Begin by installing the ``sysutils/iocage``
package or port ::

  shell> ansible-playbook -t freebsd_iocage_pkg -e freebsd_iocage_install=true iocage.yml

Activate the target storage pool for ``iocage`` ::

  shell> ansible-playbook -t freebsd_iocage_activate -e freebsd_iocage_activate=true iocage.yml

Configure ``iocage`` defaults ::

  shell> ansible-playbook -t freebsd_iocage_conf iocage.yml
  
Run sanity checks to audit and validate the installation ::

  shell> ansible-playbook -t freebsd_iocage_sanity iocage.yml
  
Configure ``rc.conf`` to manage the ``iocage`` service lifecycle, enabling
automatic startup, restarts, or shutdowns as required ::

  shell> ansible-playbook -t freebsd_iocage_rcconf iocage.yml


Hooks
^^^^^

The ``iocage`` utility internally opens a console to a jail to
retrieve its DHCP address, an operation that requires root
privileges. If you run ``iocage list -l`` as an unprivileged user, the
IP4 field displays ``DHCP (running -- address requires root)``.  If
granting root or ``sudo`` privileges is not desired, configure
``/etc/dhclient-exit-hooks`` inside the jail to record the assigned
address. For example:

.. code-block:: sh

   # /zroot/iocage/jails/srv_1/root/etc/dhclient-exit-hooks
   case "$reason" in
       "BOUND"|"REBIND"|"REBOOT"|"RENEW")
       echo "$new_ip_address" > "/var/db/dhclient-hook.address.$interface"
       ;;
   esac

where ``/zroot/iocage`` is the activated ZFS pool:

.. code-block:: console
   :emphasize-lines: 1

   shell> zfs list | grep /zroot/iocage
   zroot/iocage                                4.69G   446G  5.08M  /zroot/iocage
   zroot/iocage/download                        927M   446G   384K  /zroot/iocage/download
   zroot/iocage/download/14.1-RELEASE           465M   446G   465M  /zroot/iocage/download/14.1-RELEASE
   zroot/iocage/download/14.2-RELEASE           462M   446G   462M  /zroot/iocage/download/14.2-RELEASE
   zroot/iocage/images                          384K   446G   384K  /zroot/iocage/images
   zroot/iocage/jails                           189M   446G   480K  /zroot/iocage/jails
   zroot/iocage/jails/srv_1                    62.9M   446G   464K  /zroot/iocage/jails/srv_1
   zroot/iocage/jails/srv_1/root               62.4M   446G  3.53G  /zroot/iocage/jails/srv_1/root
   zroot/iocage/jails/srv_2                    62.8M   446G   464K  /zroot/iocage/jails/srv_2
   zroot/iocage/jails/srv_2/root               62.3M   446G  3.53G  /zroot/iocage/jails/srv_2/root
   zroot/iocage/jails/srv_3                    62.8M   446G   464K  /zroot/iocage/jails/srv_3
   zroot/iocage/jails/srv_3/root               62.3M   446G  3.53G  /zroot/iocage/jails/srv_3/root
   zroot/iocage/log                             688K   446G   688K  /zroot/iocage/log
   zroot/iocage/releases                       2.93G   446G   384K  /zroot/iocage/releases
   zroot/iocage/releases/14.2-RELEASE          2.93G   446G   384K  /zroot/iocage/releases/14.2-RELEASE
   zroot/iocage/releases/14.2-RELEASE/root     2.93G   446G  2.88G  /zroot/iocage/releases/14.2-RELEASE/root
   zroot/iocage/templates                       682M   446G   416K  /zroot/iocage/templates
   zroot/iocage/templates/ansible_client        681M   446G   432K  /zroot/iocage/templates/ansible_client
   zroot/iocage/templates/ansible_client/root   681M   446G  3.53G  /zroot/iocage/templates/ansible_client/root

.. seealso:: `man dhclient-script`_

Update the inventory configuration ``hosts/02_iocage.yml`` to use the
``hooks_results`` parameter instead of ``sudo``:

.. code-block:: yaml

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b

.. note::

   The ``hooks_results`` parameter expects the active pool to be
   mounted at ``/<poolname>``. For example, if you activate the pool
   ``zroot``, the plugin expects to find ``hooks_results`` files at
   ``/zroot/iocage/jails/<name>/root``.  If your pool is mounted
   elsewhere, create a symlink to this path.

As admin on the control node, display the inventory:

.. code-block:: console

   (env) > ansible-inventory -i hosts/02_iocage.yml --list --yaml

.. code-block:: yaml

   all:
     children:
       ungrouped:
         hosts:
           srv_1:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_hooks:
             - 10.1.0.183
             iocage_ip4: '-'
             iocage_ip4_dict:
               ip4: []
               msg: DHCP (running -- address requires root)
             iocage_ip6: '-'
             iocage_jid: '204'
             iocage_release: 14.2-RELEASE-p3
             iocage_state: up
             iocage_template: ansible_client
             iocage_type: jail
           srv_2:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_hooks:
             - 10.1.0.204
             iocage_ip4: '-'
             iocage_ip4_dict:
               ip4: []
               msg: DHCP (running -- address requires root)
             iocage_ip6: '-'
             iocage_jid: '205'
             iocage_release: 14.2-RELEASE-p3
             iocage_state: up
             iocage_template: ansible_client
             iocage_type: jail
           srv_3:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_hooks:
             - 10.1.0.169
             iocage_ip4: '-'
             iocage_ip4_dict:
               ip4: []
               msg: DHCP (running -- address requires root)
             iocage_ip6: '-'
             iocage_jid: '206'
             iocage_release: 14.2-RELEASE-p3
             iocage_state: up
             iocage_template: ansible_client
             iocage_type: jail

Update ``hosts/02_iocage.yml`` to compose ``ansible_host`` from the
hook output:

.. code-block:: yaml+jinja
   :emphasize-lines: 7

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b
   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)

To test connectivity to the jails, create the playbook
``pb-test-uname.yml``:

.. code-block:: yaml

   - hosts: all
     remote_user: admin

     vars:
       ansible_python_interpreter: auto_silent

     tasks:
       - name: Run uname
         ansible.builtin.command: uname -a
         register: out

       - name: Display uname output
         ansible.builtin.debug:
           var: out.stdout

.. seealso:: `Managing BSD hosts with Ansible`_

Run the playbook:

.. code-block:: console

   (env) > ansible-playbook -i hosts/02_iocage.yml pb-test-uname.yml

.. code-block:: text

   PLAY [all] **********************************************************************************************************

   TASK [Run uname] ****************************************************************************************************
   changed: [srv_3]
   changed: [srv_1]
   changed: [srv_2]

   TASK [Display uname] ************************************************************************************************
   ok: [srv_1] =>
       out.stdout: FreeBSD srv-1 14.2-RELEASE-p1 FreeBSD 14.2-RELEASE-p1 GENERIC amd64
   ok: [srv_3] =>
       out.stdout: FreeBSD srv-3 14.2-RELEASE-p1 FreeBSD 14.2-RELEASE-p1 GENERIC amd64
   ok: [srv_2] =>
       out.stdout: FreeBSD srv-2 14.2-RELEASE-p1 FreeBSD 14.2-RELEASE-p1 GENERIC amd64

   PLAY RECAP **********************************************************************************************************
   srv_1                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   srv_2                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   srv_3                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

.. note:: 

   This playbook and inventory configuration also work with `Shared IP
   jails`_.

.. _ug_examples:

Examples
********

:001-: Manage iocage
:010-: `Module`_, `Inventory`_ and `Filter`_ ``vbotka.freebsd.iocage``
:040-: Other plugins
:200-: Ansible client
:300-: Modules
:310-: `Role vbotka.freebsd.postinstall`_
:320-: `Role vbotka.freebsd.packages`_
:330-: `Role vbotka.freebsd.iocage`_
:340-: `Role vbotka.freebsd.config_light`_
:350-: `Role vbotka.freebsd.rsnapshot`_
:360-: `Role vbotka.freebsd.network`_
:370-: `Role vbotka.freebsd.pf`_
:380-: `Role vbotka.freebsd.custom_image`_
:390-: `Role vbotka.freebsd.poudriere`_
:400-: `Role vbotka.freebsd.zfs`_
:410-: `Role vbotka.freebsd.lib`_
:420-: `Role vbotka.freebsd.apache`_
:430-: `Role vbotka.freebsd.certificate`_
:440-: `Role vbotka.freebsd.dhcp`_
:500-: Infrastructure

.. note::

   * The examples that create jails use the iocage host setting created in the example
     :ref:`example_440` by default. The firewall is on both the external interface and the ``vnet``
     bridge of the iocage host. DHCP for the jails is on the bridge, and SSH access from the local
     network to the jails is redirected. Examples that do not use this setting are marked ``.deny``,
     meaning they are excluded from ``batch.sh``. To run these examples, the firewall must be
     reconfigured; see :ref:`example_370`.

   * All examples include additional files that are not displayed in the file tree. Review these
     files for more details.

   * The examples include a ``batch.sh`` script that executes the commands and generates the output
     for each example.

   * Most playbooks in ``batch.sh`` are idempotent. If a playbook is run repeatedly, the output may
     display a status of ``ok`` instead of the expected ``changed``.

   * The playbooks in the examples use dashes (``-``) in their filenames (e.g. ``pb-iocage.yml``).

   * Due to Ansible collection naming conventions, the playbooks in the collection use underscores
     (``_``) in their filenames (e.g. ``pb_iocage_template.yml``).

   * To avoid connection errors in examples where DHCP is used, ``host_key_checking = false`` can be
     configured in ``ansible.cfg``.

.. hint:: See :ref:`dg_update_examples`.
  
.. toctree::
   :maxdepth: 1
   :caption: Manage iocage

   001 Debug vars and install iocage <examples/001/example.rst>
   002 Activate iocage <examples/002/example.rst>
   003 Audit iocage hosts <examples/003/example.rst>

.. toctree::
   :maxdepth: 1
   :caption: iocage module, inventory, and filter

   010 Clone jails and create inventory <examples/010/example.rst>
   examples/011/example.rst
   examples/012/example.rst
   examples/013/example.rst
   examples/014/example.rst
   examples/015/example.rst
   examples/016/example.rst
   examples/017/example.rst
   examples/018/example.rst
   examples/019/example.rst
   examples/020/example.rst
   examples/030/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Plugins

   examples/040/example.rst
   examples/050/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Ansible client

   200 iocage templates <examples/200/example.rst>
   201 iocage datasets <examples/201/example.rst>
   202 DHCP iocage templates <examples/202/example.rst>
   203 DHCP, auto UUID, iocage_tags <examples/203/example.rst>
   204 DHCP, auto UUID, iocage_tags v2 <examples/204/example.rst>
   206 DHCP and fixed IP clients <examples/206/example.rst>
   207 DHCP, auto UUID, tags, class <examples/207/example.rst>
   208 DHCP, ansible_client_pull <examples/208/example.rst>
   209 pkglist, ansible_client_apache <examples/209/example.rst>
   210 iocage notes and tags <examples/210/example.rst>

.. toctree::
   :maxdepth: 1
   :caption: Modules

   examples/300/example.rst
   examples/301/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Roles

   310 Configure and audit Ansible clients <examples/310/example.rst>
   examples/311/example.rst
   320 Install and audit packages <examples/320/example.rst>
   321 Create package repo configuration <examples/321/example.rst>
   330 Clone jails and create inventory <examples/330/example.rst>
   340 Install and configure lighttpd <examples/340/example.rst>
   350 Install and configure rsnapshot <examples/350/example.rst>
   examples/360/example.rst
   examples/361/example.rst
   examples/370/example.rst
   examples/380/example.rst
   examples/390/example.rst
   examples/400/example.rst
   410 Include vars from conf.d <examples/410/example.rst>
   411 Include vars from nested dirs <examples/411/example.rst>
   420 Configure Apache server <examples/420/example.rst>
   421 Configure Apache server vhost <examples/421/example.rst>
   422 Configure Apache server PHP <examples/422/example.rst>
   423 Configure Apache server build <examples/423/example.rst>
   430 Configure Apache server SSL <examples/430/example.rst>
   examples/440/example.rst
   examples/441/example.rst
   examples/442/example.rst
   examples/443/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Infrastructure

   500 syslog-ng server and clients <examples/500/example.rst>
   examples/501/example.rst
   examples/502/example.rst
   521 iocage plugins ansible-pull* <examples/521/example.rst>
   522 templates ansible_syslogng_* <examples/522/example.rst>
   523 template ansible_repos <examples/523/example.rst>
   524 template ansible_init <examples/524/example.rst>
   525 template ansible_init (class) <examples/525/example.rst>
   examples/526/example.rst


.. _Module: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage
.. _Inventory: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _Filter: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage

.. _Module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service
.. _Module vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl

.. _Role vbotka.freebsd.apache: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache
.. _Role vbotka.freebsd.certificate: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/certificate
.. _Role vbotka.freebsd.config_light: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light
.. _Role vbotka.freebsd.custom_image: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image
.. _Role vbotka.freebsd.dhcp: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/dhcp
.. _Role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage
.. _Role vbotka.freebsd.lib: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib
.. _Role vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network
.. _Role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages
.. _Role vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf
.. _Role vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _Role vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere
.. _Role vbotka.freebsd.rsnapshot: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsnapshot
.. _Role vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs

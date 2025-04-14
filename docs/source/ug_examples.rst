.. _ug_examples:

Examples
********

:001-003: Manage *iocage* on the remote host
:010-019: `Module vbotka.freebsd.iocage`_ and `Inventory vbotka.freebsd.iocage`_
:030:     `Filter vbotka.freebsd.iocage`_
:200-:    Ansible client
:300:     `Module vbotka.freebsd.service`_
:301:     `Module vbotka.freebsd.ucl`_
:310:     `Role vbotka.freebsd.postinstall`_
:311:     `Role vbotka.freebsd.packages`_
:312:     `Role vbotka.freebsd.iocage`_
:313:     `Role vbotka.freebsd.config_light`_
:314:     `Role vbotka.freebsd.rsnapshot`_

.. toctree::
   :maxdepth: 1
   :caption: Table of Contents

   001 Debug vars and install iocage <examples/001/example.rst>
   002 Activate iocage <examples/002/example.rst>
   003 Audit iocage hosts <examples/003/example.rst>
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
   examples/030/example.rst
   200 Ansible client templates <examples/200/example.rst>
   201 Display iocage lists <examples/201/example.rst>
   202 DHCP Ansible client templates <examples/202/example.rst>
   203 DHCP, Auto UUID, iocage_tags <examples/203/example.rst>
   204 DHCP, Auto UUID, iocage_tags v2 <examples/204/example.rst>
   205 DHCP Ansible client templates v2 <examples/205/example.rst>
   206 DHCP and fixed IP Ansible clients <examples/206/example.rst>
   examples/300/example.rst
   examples/301/example.rst
   310 Configure and audit Ansible clients <examples/310/example.rst>
   311 Install and audit packages <examples/311/example.rst>
   312 Clone jails and create inventory <examples/312/example.rst>
   313 Install and configure lighttpd <examples/313/example.rst>
   314 Install and configure rsnapshot <examples/314/example.rst>


.. _Module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _Module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/
.. _Module vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/

.. _Inventory vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _Filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/

.. _Role vbotka.freebsd.config_light: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light/
.. _Role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _Role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _Role vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _Role vbotka.freebsd.rsnapshot: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsnapshot/

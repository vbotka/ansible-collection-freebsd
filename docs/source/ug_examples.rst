.. _ug_examples:

Examples
********

:001-: Manage iocage hosts
:010-: iocage plugins
:040-: Other plugins
:200-: Ansible client
:300-: Modules
:310-: Roles
:500-: Infrastructure
  
.. toctree::
   :maxdepth: 1
   :caption: Manage iocage hosts

   001 Debug vars and install iocage <examples/001/example.rst>
   002 Activate iocage <examples/002/example.rst>
   003 Audit iocage hosts <examples/003/example.rst>

.. toctree::
   :maxdepth: 1
   :caption: iocage inventory, filter, and module

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
   020 Inventory aliases from notes <examples/020/example.rst>
   examples/021/example.rst
   examples/030/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Plugins

   examples/040/example.rst
   examples/041/example.rst
   examples/042/example.rst
   examples/043/example.rst
   examples/044/example.rst
   examples/045/example.rst
   examples/050/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Ansible client

   200 Created jails from templates <examples/200/example.rst>
   201 Display iocage datasets <examples/201/example.rst>
   202 DHCP, Create jails from templates <examples/202/example.rst>
   203 DHCP, auto UUID, iocage_tags <examples/203/example.rst>
   204 DHCP, auto UUID, iocage_tags v2 <examples/204/example.rst>
   206 DHCP and fixed IP clients <examples/206/example.rst>
   207 DHCP, auto UUID, tags, class <examples/207/example.rst>
   208 DHCP, ansible-client-pull <examples/208/example.rst>
   209 iocage pkglist, ansible-apache <examples/209/example.rst>
   210 iocage notes and tags <examples/210/example.rst>

.. toctree::
   :maxdepth: 1
   :caption: Modules

   300 Module service <examples/300/example.rst>
   301 Module ucl <examples/301/example.rst>

.. toctree::
   :maxdepth: 1
   :caption: Roles

   310 Configure and audit Ansible clients <examples/310/example.rst>
   examples/311/example.rst
   320 Install and audit packages <examples/320/example.rst>
   321 Poudriere package repo <examples/321/example.rst>
   322 Local package repo <examples/322/example.rst>
   330 Clone jails and create inventory <examples/330/example.rst>
   340 lighttpd <examples/340/example.rst>
   350 rsnapshot <examples/350/example.rst>
   360 bridge <examples/360/example.rst>
   361 loadbalance <examples/361/example.rst>
   370 PF <examples/370/example.rst>
   380 Custom image <examples/380/example.rst>
   examples/390/example.rst
   400 ZFS <examples/400/example.rst>
   410 Include vars from conf.d <examples/410/example.rst>
   411 Include vars from nested dirs <examples/411/example.rst>
   420 Apache server <examples/420/example.rst>
   421 Apache server vhost <examples/421/example.rst>
   422 Apache server PHP <examples/422/example.rst>
   423 Apache server Poudriere <examples/423/example.rst>
   430 Apache server SSL <examples/430/example.rst>
   435 Nginx server <examples/435/example.rst>
   436 HAProxy loadbalancer <examples/436/example.rst>
   437 HAProxy loadbalancer (swarm) <examples/437/example.rst>
   440 DHCP and PF <examples/440/example.rst>
   examples/441/example.rst
   examples/442/example.rst
   examples/443/example.rst

.. toctree::
   :maxdepth: 1
   :caption: Infrastructure

   500 syslog-ng server and clients <examples/500/example.rst>
   examples/501/example.rst
   examples/502/example.rst
   521 iocage plugins ansible-pull-* <examples/521/example.rst>
   522 Templates ansible-syslogng-* <examples/522/example.rst>
   523 Template ansible-repos <examples/523/example.rst>
   524 Template ansible-init <examples/524/example.rst>
   525 Template ansible-init (class) <examples/525/example.rst>
   526 Log srv/client (ansible-init) <examples/526/example.rst>
   527 Template ansible-pkg-repo <examples/527/example.rst>
   528 Log srv/client (ansible-conf-roles) <examples/528/example.rst>
   529 Template ansible-init (local repo) <examples/529/example.rst>
   530 Creat all templates <examples/530/example.rst>

.. _ug_examples_notes:
.. include:: ug_examples_notes.rst

.. hint::

   See :ref:`dg_update_examples`.

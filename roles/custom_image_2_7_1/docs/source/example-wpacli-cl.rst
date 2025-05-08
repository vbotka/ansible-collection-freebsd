.. _ug_example_002:

Configure wpa_cli by config_light
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To configure the image, we'll use Ansible role `vbotka.config_light
<https://galaxy.ansible.com/vbotka/config_light>`_, instead of the :ref:`ug_tasks`. This example,
using *config_light*, configures exactly the same parameters of the wireless network as the role
`vbotka.freebsd_wpa_cli <https://galaxy.ansible.com/vbotka/freebsd_wpa_cli>`_. Review the goal of
`Ansible role FreeBSD wpa_cli
<https://ansible-freebsd-wpa-cli.readthedocs.io/en/latest/index.html>`_ and read at least the
`Introduction
<https://ansible-freebsd-wpa-cli.readthedocs.io/en/latest/guide.html#introduction>`_. The purpose of
using the role *config_light*, instead of *freebsd_wpa_cli*, is building single source of the
configuration in the directory ``cl_dird``.

The playbook ``pb-wifi-basic.yml`` created in the :ref:`qg` will be used to attach a memory disk and
mount the partition.

* Current directory reuses the data from the previous example ::

    shell> ls -1
    conf-light
    files
    hosts
    pb-wpacli-cl.yml
    pb-wifi-basic.yml

* Install the role ``vbotka.config_light`` ::

    shell> ansible-galaxy install vbotka.freebsd_config_light

* Create the playbook ``pb-wpacli-cl.yml`` for single host images.example.com (2). Configure
  connection (4-5) and privilege escalation (6-8). Configure the directory (13) with the
  configuration files and reuse the configuration (15-18) already prepared in :ref:`qg`
  (28-52). Configure only wlan0 (19) in wpa_supplicant. The configuration of *wpa_cli* (58-78) is
  described in Ansible role `vbotka.freebsd_wpa_cli
  <https://galaxy.ansible.com/vbotka/freebsd_wpa_cli>`_. The configuration of *ntp* (81-94) is
  described in Ansible role `vbotka.freebsd_postinstall
  <https://galaxy.ansible.com/vbotka/freebsd_postinstall>`_.

.. literalinclude:: ../../contrib/example-wpacli-cl/pb-wpacli-cl.yml
  :caption: [`contrib/example-wpacli-cl/pb-wpacli-cl.yml <https://raw.githubusercontent.com/vbotka/ansible-freebsd-custom-image/master/contrib/example-wpacli-cl/pb-wpacli-cl.yml>`_]
  :lines: 27-123
  :language: yaml
  :emphasize-lines: 2,4-8,13,15-18,19,58-78,81-94
  :linenos:

* Create the configuration files in the directory ``cl_dird`` ::

    shell> tree conf-light/
    conf-light/
    ├── files.d
    │   ├── defaults-rc-conf.yml
    │   ├── loader-conf.yml
    │   ├── network_subr.yml
    │   ├── ntp-conf.yml
    │   ├── rc-conf.yml
    │   ├── wpa-action-sh.yml
    │   ├── wpa-cli.yml
    │   └── wpasup-conf-wlan0.yml
    ├── handlers.d
    ├── packages.d
    ├── services.d
    └── states.d
        ├── root-bin.yml
        └── wpasup-conf.yml


* Create the directory wiht the patches ::

    shell> tree files/
    files/
    ├── network.subr.patch
    └── rc.conf.patch

<TODO: Details in ``contrib/example-wpacli-cl``>


.. seealso:: How to configure `Files in vbotka.config_light <https://ansible-config-light.readthedocs.io/en/latest/guide.html#files>`_


* Create the inventory. Change the IP adress (2) and fit the paths to Python (8) and Perl (9) if
  necessary

.. code-block:: sh
   :emphasize-lines: 2,8-9
   :linenos:

    shell> cat hosts
    images.example.com ansible_host=<ip-address>

    [images]
    images.example.com

    [images:vars]
    ansible_python_interpreter=/usr/local/bin/python3.7
    ansible_perl_interpreter=/usr/local/bin/perl

* Mount the image using the playbook prepared in :ref:`qg` ::

   shell> ansible-playbook pb-wifi-basic.yml -t cimage_mount

* Test syntax ::

    shell> ansible-playbook pb-wpacli-cl.yml --syntax-check

* See what variables will be included ::

    shell> ansible-playbook pb-wpacli-cl.yml -t cl_debug -e cl_debug=true

* Run the playbook ::

    shell> ansible-playbook pb-wpacli-cl.yml

* Umount the partition and detach the memory disk ::

   shell> ansible-playbook pb-wifi-basic.yml -t cimage_umount

* Write the customized image to a disk and boot the system. Connect to the system and review the
  log. For example ::

   shell> cat /tmp/wpa_action.wlan0

   Jan 21 06:29:49 wlan0: CONNECTED
   Jan 21 06:29:50 wlan0: SSID: my-access-point
   Jan 21 06:29:57 wlan0: /etc/rc.d/dhclient forcestart wlan0: Starting dhclient.
   DHCPREQUEST on wlan0 to 255.255.255.255 port 67
   DHCPACK from 10.1.0.1
   bound to 10.1.0.16 -- renewal in 21600 seconds.
   Jan 21 06:30:03 wlan0: /etc/rc.d/routing restart: delete host 127.0.0.1: gateway lo0
   route: route has not been found
   delete net default: gateway 10.1.0.10 fib 0: not in table
   default              10.1.0.1             -fib 0   done
   route: route has not been found
   delete host ::1: gateway lo0 fib 0: not in table
   delete net fe80::: gateway ::1
   delete net ff02::: gateway ::1
   delete net ::ffff:0.0.0.0: gateway ::1
   delete net ::0.0.0.0: gateway ::1
   add host 127.0.0.1: gateway lo0
   add net default: gateway 10.1.0.10
   add host ::1: gateway lo0 fib 0: route already in table
   add net fe80::: gateway ::1
   add net ff02::: gateway ::1
   add net ::ffff:0.0.0.0: gateway ::1
   add net ::0.0.0.0: gateway ::1
   Jan 21 06:30:04 wlan0: /etc/rc.d/ntpd stop: ntpd not running? (check /var/db/ntp/ntpd.pid).
   Jan 21 06:31:05 wlan0: /usr/sbin/ntpdate -b 0.pool.ntp.org: 21 Jan 06:31:05 ntpdate[999]: step time server 62.168.94.161 offset +54.261588 sec
   Jan 21 06:31:08 wlan0: /etc/rc.d/ntpd start: Starting ntpd.

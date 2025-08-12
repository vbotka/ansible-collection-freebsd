.. _qg:

Quick start guide
*****************

For the users who want to try the role quickly, this guide provides an example of how to configure
wireless network in `already downloaded image`_. Three files will be customized in the image

1) /boot/loader.conf ::

    # cimage_loaderconf_data
    hw.usb.template=3
    umodem_load="YES"
    boot_multicons="YES"
    boot_serial="YES"
    beastie_disable="YES"
    loader_color="NO"
    legal.realtek.license_ack=1

    # cimage_loaderconf_sysctl

    # cimage_loaderconf_modules
    wlan_load="YES"
    wlan_wep_load="YES"
    wlan_ccmp_load="YES"
    wlan_tkip_load="YES"
    wlan_amrr_load="YES"
    rtwn_load="YES"
    if_rtwn_usb_load="YES"

2) /etc/rc.conf ::

     wlans_rtwn0="wlan0"
     ifconfig_wlan0="WPA SYNCDHCP"

3) /etc/wpa_supplicant.conf ::

     network={
             ssid="my_access_point"
             psk="my_password"
             disabled=0
             }

After the configuration of the files is ready dump the image to a disk and boot the system. The
wireless adapter should automatically connect to the network and obtain DHCP address. It should be
possible to connect to the system ``ssh freebsd@<ip-address>`` (default passwords of FreeBSD images
are ``freebsd: freebsd`` and ``root: root``).

The wireless adapter in this example is `USB Realtek RTL8188EU`_ (idVendor =
0x0bda idProduct = 0x8179) ::

  rtwn0: <Realtek 802.11n NIC, class 0/0, rev 2.00/0.00, addr 4> on usbus1
  rtwn0: MAC/BB RTL8188EU, RF 6052 1T1R

.. seealso::

   * `7.4. Wireless Networks - FreeBSD Handbook`_
   * `34.4. Wireless Advanced Authentication - FreeBSD Handbook`_
   * `Wiki FreeBSD Wireless`_
   * `FreeBSD Release Notes`_
   * `man pages of supported wireless devices`_

Follow the steps below

* Install the role ``vbotka.freebsd_custom_image`` ::

    shell> ansible-galaxy role install vbotka.freebsd_custom_image

* Install the collections `community.general`_, `ansible.posix`_, and `vbotka.freebsd`_ if necessary
  ::

    shell> ansible-galaxy collection install ansible.posix
    shell> ansible-galaxy collection install community.general
    shell> ansible-galaxy collection install vbotka.freebsd

* Create the playbook ``pb-wifi-basic.yml`` for single host images.example.com (2). Configure
  connection (4-5) and privilege escalation (6-8). Configure the path (16) to the image (17) and
  make sure the image is writable by root. The default system partition is ``s2a`` (19). Configure
  the mount-point(s) (21) and configure which partition will be customized (22). The mount-point
  doesn't have to exist and will be create (and later deleted when unmounted) by the Ansible module
  ``ansible.posix.mount``. Review the modules (26) and loader's configuration (27-34). Fit it to
  your needs if you use a different adapter. Change also the configuration of ``/etc/rc.conf``
  (38-40) if necessary. Change ``SSID`` (48) and ``password`` (49) of the access point. Enable
  symbolic link of ``/etc/wpa_supplicant.conf`` to ``/etc/wpa_supplicant.conf.wlan0`` (51, 52).

.. literalinclude:: ../../contrib/playbook/pb-wifi-basic.yml
  :caption: `contrib/playbook/pb-wifi-basic.yml`_
  :lines: 32-87
  :language: yaml
  :emphasize-lines: 2,4-8,16,17,19,21,22,26,27-34,38-40,48,49,51,52
  :linenos:

* Create the inventory ``hosts``. Change the IP address (1) and fit the paths to Python (7) and
  Perl (8) if necessary

.. code-block:: ini
   :linenos:

    images.example.com ansible_host=<ip-address>

    [images]
    images.example.com

    [images:vars]
    ansible_python_interpreter=/usr/local/bin/python3.11
    ansible_perl_interpreter=/usr/local/bin/perl

* Test the syntax ::

    shell> ansible-playbook pb-wifi-basic.yml --syntax-check

* See what variables will be included ::

    shell> ansible-playbook pb-wifi-basic.yml -t cimage_debug -e cimage_debug=true

* Run the playbook ::

    shell> ansible-playbook pb-wifi-basic.yml

.. note::

    * By default, the role is not idempotent. At least 4 tasks will be reported changed: 1) Create
      memory disk 2) Mount mdX partitions 3) Unmount mount points 4) Detach memory disk.

    * Setting ``cimage_umount=false`` will keep the memory disk attached and partitions
      mounted. This will make the role idempotent.

.. warning::

  * Password of the access-point will be displayed. Set classified debug to false
    ``cimage_debug_classified=false`` to prevent it.
  
  * The image has not been secured by this playbook and should be used for testing only.

* Make sure the partition is unmounted and write the customized image to a disk. For example, ::

    dd if=FreeBSD-13.5-RELEASE-arm-armv6-RPI-B.img of=/dev/sdX bs=1m conv=sync status=progress

.. hint:: In Linux, use ``bs=1M``

.. seealso:: `2.3. Pre-Installation Tasks`_

.. warning:: Change the device. Double-check that this is the correct device and make sure you don't
             overwrite important data.

* Boot the system. Find the IP address from the console or from the DHCP server if headless. Connect
  to the system

  .. code-block:: console

     shell> ssh freebsd@10.1.0.16
     Password for freebsd@rpi-b:
     FreeBSD 13.5-RELEASE releng/13.5-n259162-882b9f3f2218 RPI-B

     Welcome to FreeBSD!
     ...

     freebsd@rpi-b:~ % dmesg
     Copyright (c) 1992-2021 The FreeBSD Project.
     Copyright (c) 1979, 1980, 1983, 1986, 1988, 1989, 1991, 1992, 1993, 1994
             The Regents of the University of California. All rights reserved.
     FreeBSD is a registered trademark of The FreeBSD Foundation.
     FreeBSD 13.5-RELEASE releng/13.5-n259162-882b9f3f2218 RPI-B arm
     FreeBSD clang version 19.1.7 (https://github.com/llvm/llvm-project.git llvmorg-19.1.7-0-gcd708029e0b2)

     ...

  .. code-block:: console

     freebsd@rpi-b:~ % ifconfig wlan0
     wlan0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
             ether <sanitized>
             inet6 fe80::272:63ff:fe20:599f%wlan0 prefixlen 64 scopeid 0x2
             inet6 fdb2:96f:84ff:0:272:63ff:fe20:599f prefixlen 64 autoconf
             inet 10.1.0.16 netmask 0xffffff00 broadcast 10.1.0.255
             groups: wlan
             ssid <sanitized> channel 6 (2437 MHz 11g ht/20) bssid <sanitized>
             regdomain FCC country US authmode WPA2/802.11i privacy ON
             deftxkey UNDEF AES-CCM 2:128-bit AES-CCM 3:128-bit txpower 30 bmiss 7
             scanvalid 60 protmode CTS ht20 ampdulimit 64k ampdudensity 8 shortgi
             -stbc -ldpc -uapsd wme roaming MANUAL
             parent interface: rtwn0
             media: IEEE 802.11 Wireless Ethernet MCS mode 11ng
             status: associated
             nd6 options=23<PERFORMNUD,ACCEPT_RTADV,AUTO_LINKLOCAL>


.. _already downloaded image: https://www.freebsd.org/where.html
.. _USB Realtek RTL8188EU: https://man.freebsd.org/cgi/man.cgi?query=rtwn&sektion=4&format=html
.. _7.4. Wireless Networks - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/network/#network-wireless
.. _34.4. Wireless Advanced Authentication - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/advanced-networking/#network-advanced-wireless
.. _Wiki FreeBSD Wireless: https://wiki.freebsd.org/WiFi
.. _FreeBSD Release Notes: https://www.freebsd.org/releases/index.html
.. _man pages of supported wireless devices: https://wiki.freebsd.org/DeviceDrivers

.. _community.general: https://docs.ansible.com/ansible/latest/collections/community/general
.. _ansible.posix: https://docs.ansible.com/ansible/latest/collections/ansible/posix
.. _vbotka.freebsd: https://ansible-collection-freebsd.readthedocs.io/en/latest/

.. _contrib/playbook/pb-wifi-basic.yml: https://raw.githubusercontent.com/vbotka/ansible-freebsd-custom-image/master/contrib/playbook/pb-wifi-basic.yml
.. _2.3. Pre-Installation Tasks: https://www.freebsd.org/doc/handbook/bsdinstall-pre.html

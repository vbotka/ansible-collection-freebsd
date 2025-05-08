.. _qg:

Quick start guide
*****************

For the users who want to try the role quickly, this guide provides an example of how to configure
wireless network in `already downloaded image <https://www.freebsd.org/where.html>`_. Three files
will be customized in the image

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

The wireless adapter in this example is `USB Realtek RTL8188EU <https://man.freebsd.org/cgi/man.cgi?query=rtwn&sektion=4&format=html>`_
(idVendor = 0x0bda idProduct = 0x8179) ::

    rtwn0: <Realtek 802.11n NIC, class 0/0, rev 2.00/0.00, addr 4> on usbus1
    rtwn0: MAC/BB RTL8188EU, RF 6052 1T1R


.. seealso::
   * `7.4. Wireless Networks - FreeBSD Handbook <https://docs.freebsd.org/en/books/handbook/network/#network-wireless>`_
   * `34.4. Wireless Advanced Authentication - FreeBSD Handbook <https://docs.freebsd.org/en/books/handbook/advanced-networking/#network-advanced-wireless>`_
   * `Wiki FreeBSD Wireless <https://wiki.freebsd.org/WiFi>`_
   * `FreeBSD Release Notes <https://www.freebsd.org/releases/index.html>`_
   * `man pages of supported wireless devices <https://wiki.freebsd.org/DeviceDrivers>`_


Follow the steps below


* Install the role ``vbotka.freebsd_custom_image`` ::

    shell> ansible-galaxy role install vbotka.freebsd_custom_image

* Install the library ``vbotka.ansible_lib`` ::

    shell> ansible-galaxy role install vbotka.ansible_lib

* Install the collections
  `community.general <https://docs.ansible.com/ansible/latest/collections/community/general/>`_
  and `ansible.posix <https://docs.ansible.com/ansible/latest/collections/ansible/posix/index.html#plugins-in-ansible-posix/>`_  if necessary ::

    shell> ansible-galaxy collection install ansible.posix
    shell> ansible-galaxy collection install community.general

* Create the playbook ``pb-wifi-basic.yml`` for single host images.example.com (2). Configure
  connection (4-5) and privilege escalation (6-8). Configure the path (16) to the image (17) and
  make sure the image is writable by root. The default system partition is *s2a* (19). Configure the
  mount-point(s) (21) and configure which partition will be customized (22). The mount-point doesn't
  have to exist and will be create (and later deleted when unmounted) by the Ansible module
  *mount*. Review the modules (26) and loader's configuration (27-34). Fit it to your needs if you
  use a different adapter. Change also configuration of *rc.conf* (38-40) if necessary. Change
  *SSID* (48) and *password* (49) of the access point. Enable symbolic link of
  */etc/wpa_supplicant.conf* to */etc/wpa_supplicant.conf.wlan0* (51,52).

.. literalinclude:: ../../contrib/playbook/pb-wifi-basic.yml
  :caption: [`contrib/playbook/pb-wifi-basic.yml <https://raw.githubusercontent.com/vbotka/ansible-freebsd-custom-image/master/contrib/playbook/pb-wifi-basic.yml>`_]
  :lines: 32-87
  :language: yaml
  :emphasize-lines: 2,4-8,16,17,19,21,22,26,27-34,38-40,48,49,51,52
  :linenos:


* Create the inventory. Change the IP address (2) and fit the paths to Python (8) and Perl (9) if
  necessary

.. code-block:: sh
   :emphasize-lines: 2,8-9
   :linenos:

    shell> cat hosts
    images.example.com ansible_host=<ip-address>

    [images]
    images.example.com

    [images:vars]
    ansible_python_interpreter=/usr/local/bin/python3.9
    ansible_perl_interpreter=/usr/local/bin/perl


* Test syntax ::

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

  * Password of the access-point will be displayed. Set classified debug to *false*
    ``cimage_debug_classified=false`` to prevent it.
  
  * The image has not been secured by this playbook and should be used for testing only.


* Make sure the partition is unmounted and write the customized image to a disk. For example ::

    dd if=FreeBSD-13.0-CURRENT-arm-armv6-RPI-B-20201231-282381aa53a-255460.img of=/dev/sdX bs=1m conv=sync status=progress

.. seealso:: `2.3. Pre-Installation Tasks <https://www.freebsd.org/doc/handbook/bsdinstall-pre.html>`_

.. warning:: Change the device of the disk. Double-check that this is the correct device and make
             sure you don't overwrite important data.


* Boot the system. Find the IP address either from the console or from the DHCP server, if headless,
  and connect to the system ::

    shell> ssh freebsd@10.1.0.16
    Password for freebsd@rpi-b:
      FreeBSD 13.0-CURRENT (RPI-B) #0 main-c255460-g282381aa53a: Thu Dec 31 08:07:25 UTC 2020

      Welcome to FreeBSD!

    ...

    freebsd@rpi-b:~ % dmesg
    ---<<BOOT>>---
    KDB: debugger backends: ddb
    KDB: current backend: ddb
    Copyright (c) 1992-2020 The FreeBSD Project.
    Copyright (c) 1979, 1980, 1983, 1986, 1988, 1989, 1991, 1992, 1993, 1994
    The Regents of the University of California. All rights reserved.
    FreeBSD is a registered trademark of The FreeBSD Foundation.
    FreeBSD 13.0-CURRENT #0 main-c255460-g282381aa53a: Thu Dec 31 08:07:25 UTC 2020
        root@releng1.nyi.freebsd.org:/usr/obj/usr/src/arm.armv6/sys/RPI-B arm
        FreeBSD clang version 11.0.0 (git@github.com:llvm/llvm-project.git llvmorg-11.0.0-0-g176249bd673)

    ...

    freebsd@rpi-b:~ % ifconfig wlan0
    wlan0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> metric 0 mtu 1500
    ether <sanitized>
    inet 10.1.0.16 netmask 0xffffff00 broadcast 10.1.0.255
    groups: wlan
    ssid my_access_point channel 6 (2437 MHz 11g ht/20) bssid <sanitized>

    ...

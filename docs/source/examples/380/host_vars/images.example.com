cimage_download: false
cimage_unpack: false

# download
cimage_dir: /export/images/FreeBSD
cimage_download_images:
  - site: https://download.freebsd.org/releases/arm/armv6/ISO-IMAGES/13.5
    image: FreeBSD-13.5-RELEASE-arm-armv6-RPI-B.img.xz
    checksum: CHECKSUM.SHA512-FreeBSD-13.5-RELEASE-arm-armv6-RPI-B

# mount
cimage_mount_dir: /export/images/FreeBSD
cimage_mount_file: FreeBSD-13.5-RELEASE-arm-armv6-RPI-B.img
cimage_mount_points:
  - partition: s2a
    fstype: ufs
    mountpoint: /mnt3
cimage_mount_path: /mnt3

# rc.conf
cimage_rcconf: true
cimage_rcconf_data:
  - {key: wlans_rtwn0, value: wlan0}
  - {key: ifconfig_wlan0, value: WPA SYNCDHCP}

# wpa_supplicant.conf
cimage_wpasupconf: true
cimage_wpasupconf_template: wpa_supplicant.conf.2.j2 
cimage_wpasupconf_data:
  - dev: wlan0
    network:
      - conf:
          ssid: "{{ my_access_point }}"
          psk: "{{ my_password }}"
          disabled: 0
cimage_wpasupconf_link: true
cimage_wpasupconf_link_dev: wlan0

# postinstall
cimage_postinstall: [loader]

# postinstall loader
fp_loader_tuneables_warning: false
fp_loader_conf_file: "{{ cimage_mount_path }}/boot/loader.conf"
fp_loader_conf_template: ''
loader_states:
  hw.usb.template: '3'
  umodem_load: 'YES'
  boot_multicons: 'YES'
  boot_serial: 'YES'
  beastie_disable: 'YES'
  loader_colo: 'NO'
  legal.realtek.license_ack: '1'
fp_loader_conf: "{{ loader_states | dict2items(key_name='name') }}"
loader_modules: [wlan, wlan_wep, wlan_ccmp, wlan_tkip, wlan_amrr, rtwn, if_rtwn_usb]
fp_loader_conf_modules: "{{ dict(loader_modules | product(['YES'])) | dict2items(key_name='name') }}"

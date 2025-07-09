.. _ug_example_jail_create_12amd64:

jail create 12amd64
"""""""""""""""""""

Create the jail ::

  shell> poudriere jail -c -j 12amd64 -v 12.2-RELEASE

,or update it if it already exists ::

  shell> poudriere jail -u -j 12amd64 -v 12.2-RELEASE


.. code-block:: sh
   :emphasize-lines: 1
   :linenos:

   [root@build /usr/home/admin]# poudriere jail -c -j 12amd64 -v 12.2-RELEASE
   [00:00:00] Creating 12amd64 fs at /zroot/poudriere/jails/12amd64... done
   [00:00:00] Using pre-distributed MANIFEST for FreeBSD 12.2-RELEASE amd64
   [00:00:00] Fetching base for FreeBSD 12.2-RELEASE amd64
   /zroot/poudriere/jails/12amd64/fromftp/base.tx         174 MB  664 kBps 04m30s
   [00:04:32] Extracting base... done
   [00:05:01] Fetching src for FreeBSD 12.2-RELEASE amd64
   /zroot/poudriere/jails/12amd64/fromftp/src.txz         163 MB  583 kBps 04m48s
   [00:09:51] Extracting src... done
   [00:10:38] Fetching lib32 for FreeBSD 12.2-RELEASE amd64
   /zroot/poudriere/jails/12amd64/fromftp/lib32.t          63 MB  661 kBps 01m37s
   [00:12:16] Extracting lib32... done
   [00:12:25] Cleaning up... done
   [00:12:25] Recording filesystem state for clean... done
   [00:12:25] Upgrading using ftp
   /etc/resolv.conf -> /zroot/poudriere/jails/12amd64/etc/resolv.conf
   Looking up update.FreeBSD.org mirrors... 3 mirrors found.
   Fetching public key from update4.freebsd.org... done.
   Fetching metadata signature for 12.2-RELEASE from update4.freebsd.org... done.
   Fetching metadata index... done.
   Fetching 2 metadata files... done.
   Inspecting system... done.
   Preparing to download files... done.
   Fetching 145 patches.....10....20....30....40....50....60....70....80....90....100....110....120....130....140.. done.
   Applying patches... done.
   Fetching 1 files...  done.
   The following files will be removed as part of updating to
   12.2-RELEASE-p4:
   /etc/ssl/certs/2c543cd1.0
   /etc/ssl/certs/2e4eed3c.0
   /etc/ssl/certs/480720ec.0
   /etc/ssl/certs/7d0b38bd.0
   /etc/ssl/certs/8867006a.0
   /etc/ssl/certs/ad088e1d.0
   /etc/ssl/certs/b204d74a.0
   /etc/ssl/certs/ba89ed3b.0
   /etc/ssl/certs/c089bbbd.0
   /etc/ssl/certs/e2799e36.0
   /usr/share/certs/trusted/GeoTrust_Global_CA.pem
   /usr/share/certs/trusted/GeoTrust_Primary_Certification_Authority.pem
   /usr/share/certs/trusted/GeoTrust_Primary_Certification_Authority_-_G3.pem
   /usr/share/certs/trusted/GeoTrust_Universal_CA.pem
   /usr/share/certs/trusted/GeoTrust_Universal_CA_2.pem
   /usr/share/certs/trusted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G4.pem
   /usr/share/certs/trusted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G5.pem
   /usr/share/certs/trusted/thawte_Primary_Root_CA.pem
   /usr/share/certs/trusted/thawte_Primary_Root_CA_-_G2.pem
   /usr/share/certs/trusted/thawte_Primary_Root_CA_-_G3.pem
   /usr/src/secure/caroot/trusted/GeoTrust_Global_CA.pem
   /usr/src/secure/caroot/trusted/GeoTrust_Primary_Certification_Authority.pem
   /usr/src/secure/caroot/trusted/GeoTrust_Primary_Certification_Authority_-_G3.pem
   /usr/src/secure/caroot/trusted/GeoTrust_Universal_CA.pem
   /usr/src/secure/caroot/trusted/GeoTrust_Universal_CA_2.pem
   /usr/src/secure/caroot/trusted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G4.pem
   /usr/src/secure/caroot/trusted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G5.pem
   /usr/src/secure/caroot/trusted/thawte_Primary_Root_CA.pem
   /usr/src/secure/caroot/trusted/thawte_Primary_Root_CA_-_G2.pem
   /usr/src/secure/caroot/trusted/thawte_Primary_Root_CA_-_G3.pem
   The following files will be added as part of updating to
   12.2-RELEASE-p4:
   /etc/ssl/blacklisted/2c543cd1.0
   /etc/ssl/blacklisted/2e4eed3c.0
   /etc/ssl/blacklisted/480720ec.0
   /etc/ssl/blacklisted/7d0b38bd.0
   /etc/ssl/blacklisted/8867006a.0
   /etc/ssl/blacklisted/ad088e1d.0
   /etc/ssl/blacklisted/b204d74a.0
   /etc/ssl/blacklisted/ba89ed3b.0
   /etc/ssl/blacklisted/c089bbbd.0
   /etc/ssl/blacklisted/e2799e36.0
   /etc/ssl/certs/3fb36b73.0
   /usr/share/certs/blacklisted/GeoTrust_Global_CA.pem
   /usr/share/certs/blacklisted/GeoTrust_Primary_Certification_Authority.pem
   /usr/share/certs/blacklisted/GeoTrust_Primary_Certification_Authority_-_G3.pem
   /usr/share/certs/blacklisted/GeoTrust_Universal_CA.pem
   /usr/share/certs/blacklisted/GeoTrust_Universal_CA_2.pem
   /usr/share/certs/blacklisted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G4.pem
   /usr/share/certs/blacklisted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G5.pem
   /usr/share/certs/blacklisted/thawte_Primary_Root_CA.pem
   /usr/share/certs/blacklisted/thawte_Primary_Root_CA_-_G2.pem
   /usr/share/certs/blacklisted/thawte_Primary_Root_CA_-_G3.pem
   /usr/share/certs/trusted/NAVER_Global_Root_Certification_Authority.pem
   /usr/src/secure/caroot/blacklisted/GeoTrust_Global_CA.pem
   /usr/src/secure/caroot/blacklisted/GeoTrust_Primary_Certification_Authority.pem
   /usr/src/secure/caroot/blacklisted/GeoTrust_Primary_Certification_Authority_-_G3.pem
   /usr/src/secure/caroot/blacklisted/GeoTrust_Universal_CA.pem
   /usr/src/secure/caroot/blacklisted/GeoTrust_Universal_CA_2.pem
   /usr/src/secure/caroot/blacklisted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G4.pem
   /usr/src/secure/caroot/blacklisted/VeriSign_Class_3_Public_Primary_Certification_Authority_-_G5.pem
   /usr/src/secure/caroot/blacklisted/thawte_Primary_Root_CA.pem
   /usr/src/secure/caroot/blacklisted/thawte_Primary_Root_CA_-_G2.pem
   /usr/src/secure/caroot/blacklisted/thawte_Primary_Root_CA_-_G3.pem
   /usr/src/secure/caroot/trusted/NAVER_Global_Root_Certification_Authority.pem
   The following files will be updated as part of updating to
   12.2-RELEASE-p4:
   /bin/freebsd-version
   /lib/libcrypto.so.111
   /lib/libzfs.so.3
   /lib/libzfs_core.so.2
   /lib/libzpool.so.2
   /rescue/[
   /rescue/bectl
   /rescue/bsdlabel
   /rescue/bunzip2
   /rescue/bzcat
   /rescue/bzip2
   /rescue/camcontrol
   /rescue/cat
   /rescue/ccdconfig
   /rescue/chflags
   /rescue/chgrp
   /rescue/chio
   /rescue/chmod
   /rescue/chown
   /rescue/chroot
   /rescue/clri
   /rescue/cp
   /rescue/csh
   /rescue/date
   /rescue/dd
   /rescue/devfs
   /rescue/df
   /rescue/dhclient
   /rescue/disklabel
   /rescue/dmesg
   /rescue/dump
   /rescue/dumpfs
   /rescue/dumpon
   /rescue/echo
   /rescue/ed
   /rescue/ex
   /rescue/expr
   /rescue/fastboot
   /rescue/fasthalt
   /rescue/fdisk
   /rescue/fsck
   /rescue/fsck_4.2bsd
   /rescue/fsck_ffs
   /rescue/fsck_msdosfs
   /rescue/fsck_ufs
   /rescue/fsdb
   /rescue/fsirand
   /rescue/gbde
   /rescue/geom
   /rescue/getfacl
   /rescue/glabel
   /rescue/gpart
   /rescue/groups
   /rescue/gunzip
   /rescue/gzcat
   /rescue/gzip
   /rescue/halt
   /rescue/head
   /rescue/hostname
   /rescue/id
   /rescue/ifconfig
   /rescue/init
   /rescue/ipf
   /rescue/iscsictl
   /rescue/iscsid
   /rescue/kenv
   /rescue/kill
   /rescue/kldconfig
   /rescue/kldload
   /rescue/kldstat
   /rescue/kldunload
   /rescue/ldconfig
   /rescue/less
   /rescue/link
   /rescue/ln
   /rescue/ls
   /rescue/lzcat
   /rescue/lzma
   /rescue/md5
   /rescue/mdconfig
   /rescue/mdmfs
   /rescue/mkdir
   /rescue/mknod
   /rescue/more
   /rescue/mount
   /rescue/mount_cd9660
   /rescue/mount_msdosfs
   /rescue/mount_nfs
   /rescue/mount_nullfs
   /rescue/mount_udf
   /rescue/mount_unionfs
   /rescue/mt
   /rescue/mv
   /rescue/nc
   /rescue/newfs
   /rescue/newfs_msdos
   /rescue/nos-tun
   /rescue/pgrep
   /rescue/ping
   /rescue/ping6
   /rescue/pkill
   /rescue/poweroff
   /rescue/ps
   /rescue/pwd
   /rescue/rcorder
   /rescue/rdump
   /rescue/realpath
   /rescue/reboot
   /rescue/red
   /rescue/rescue
   /rescue/restore
   /rescue/rm
   /rescue/rmdir
   /rescue/route
   /rescue/routed
   /rescue/rrestore
   /rescue/rtquery
   /rescue/rtsol
   /rescue/savecore
   /rescue/sed
   /rescue/setfacl
   /rescue/sh
   /rescue/shutdown
   /rescue/sleep
   /rescue/spppcontrol
   /rescue/stty
   /rescue/swapon
   /rescue/sync
   /rescue/sysctl
   /rescue/tail
   /rescue/tar
   /rescue/tcsh
   /rescue/tee
   /rescue/test
   /rescue/tunefs
   /rescue/umount
   /rescue/unlink
   /rescue/unlzma
   /rescue/unxz
   /rescue/unzstd
   /rescue/vi
   /rescue/whoami
   /rescue/xz
   /rescue/xzcat
   /rescue/zcat
   /rescue/zdb
   /rescue/zfs
   /rescue/zpool
   /rescue/zstd
   /rescue/zstdcat
   /rescue/zstdmt
   /sbin/ipfw
   /sbin/rtsol
   /sbin/zpool
   /usr/bin/zinject
   /usr/bin/ztest
   /usr/include/net/if_var.h
   /usr/include/openssl/asn1err.h
   /usr/include/sys/filedesc.h
   /usr/include/sys/jail.h
   /usr/lib/libcrypto.a
   /usr/lib/libcrypto_p.a
   /usr/lib/libpam.a
   /usr/lib/libzfs.a
   /usr/lib/libzfs_core.a
   /usr/lib/libzfs_core_p.a
   /usr/lib/libzfs_p.a
   /usr/lib/libzpool.a
   /usr/lib/pam_login_access.so.6
   /usr/lib32/libcrypto.a
   /usr/lib32/libcrypto.so.111
   /usr/lib32/libcrypto_p.a
   /usr/lib32/libpam.a
   /usr/lib32/libzfs.a
   /usr/lib32/libzfs.so.3
   /usr/lib32/libzfs_core.a
   /usr/lib32/libzfs_core.so.2
   /usr/lib32/libzfs_core_p.a
   /usr/lib32/libzfs_p.a
   /usr/lib32/libzpool.a
   /usr/lib32/libzpool.so.2
   /usr/lib32/pam_login_access.so.6
   /usr/sbin/freebsd-update
   /usr/sbin/rtsold
   /usr/sbin/zdb
   /usr/sbin/zfsd
   /usr/sbin/zhack
   /usr/share/man/man2/jail.2.gz
   /usr/share/man/man2/jail_attach.2.gz
   /usr/share/man/man2/jail_get.2.gz
   /usr/share/man/man2/jail_remove.2.gz
   /usr/share/man/man2/jail_set.2.gz
   /usr/share/zoneinfo/Africa/Accra
   /usr/share/zoneinfo/Africa/Addis_Ababa
   /usr/share/zoneinfo/Africa/Algiers
   /usr/share/zoneinfo/Africa/Asmara
   /usr/share/zoneinfo/Africa/Asmera
   /usr/share/zoneinfo/Africa/Bangui
   /usr/share/zoneinfo/Africa/Brazzaville
   /usr/share/zoneinfo/Africa/Casablanca
   /usr/share/zoneinfo/Africa/Dar_es_Salaam
   /usr/share/zoneinfo/Africa/Djibouti
   /usr/share/zoneinfo/Africa/Douala
   /usr/share/zoneinfo/Africa/El_Aaiun
   /usr/share/zoneinfo/Africa/Juba
   /usr/share/zoneinfo/Africa/Kampala
   /usr/share/zoneinfo/Africa/Kinshasa
   /usr/share/zoneinfo/Africa/Lagos
   /usr/share/zoneinfo/Africa/Libreville
   /usr/share/zoneinfo/Africa/Luanda
   /usr/share/zoneinfo/Africa/Malabo
   /usr/share/zoneinfo/Africa/Mogadishu
   /usr/share/zoneinfo/Africa/Nairobi
   /usr/share/zoneinfo/Africa/Niamey
   /usr/share/zoneinfo/Africa/Porto-Novo
   /usr/share/zoneinfo/America/Belize
   /usr/share/zoneinfo/America/Dawson
   /usr/share/zoneinfo/America/Grand_Turk
   /usr/share/zoneinfo/America/Nassau
   /usr/share/zoneinfo/America/Whitehorse
   /usr/share/zoneinfo/Antarctica/Casey
   /usr/share/zoneinfo/Antarctica/Macquarie
   /usr/share/zoneinfo/Asia/Gaza
   /usr/share/zoneinfo/Asia/Hebron
   /usr/share/zoneinfo/Asia/Jerusalem
   /usr/share/zoneinfo/Asia/Tel_Aviv
   /usr/share/zoneinfo/Atlantic/Bermuda
   /usr/share/zoneinfo/Australia/ACT
   /usr/share/zoneinfo/Australia/Adelaide
   /usr/share/zoneinfo/Australia/Brisbane
   /usr/share/zoneinfo/Australia/Broken_Hill
   /usr/share/zoneinfo/Australia/Canberra
   /usr/share/zoneinfo/Australia/Currie
   /usr/share/zoneinfo/Australia/Darwin
   /usr/share/zoneinfo/Australia/Eucla
   /usr/share/zoneinfo/Australia/Hobart
   /usr/share/zoneinfo/Australia/Lindeman
   /usr/share/zoneinfo/Australia/Melbourne
   /usr/share/zoneinfo/Australia/NSW
   /usr/share/zoneinfo/Australia/North
   /usr/share/zoneinfo/Australia/Perth
   /usr/share/zoneinfo/Australia/Queensland
   /usr/share/zoneinfo/Australia/South
   /usr/share/zoneinfo/Australia/Sydney
   /usr/share/zoneinfo/Australia/Tasmania
   /usr/share/zoneinfo/Australia/Victoria
   /usr/share/zoneinfo/Australia/West
   /usr/share/zoneinfo/Australia/Yancowinna
   /usr/share/zoneinfo/Canada/Yukon
   /usr/share/zoneinfo/Europe/Budapest
   /usr/share/zoneinfo/Europe/Monaco
   /usr/share/zoneinfo/Europe/Paris
   /usr/share/zoneinfo/Europe/Volgograd
   /usr/share/zoneinfo/Indian/Antananarivo
   /usr/share/zoneinfo/Indian/Comoro
   /usr/share/zoneinfo/Indian/Mahe
   /usr/share/zoneinfo/Indian/Mayotte
   /usr/share/zoneinfo/Israel
   /usr/share/zoneinfo/Pacific/Efate
   /usr/share/zoneinfo/Pacific/Fiji
   /usr/share/zoneinfo/zone.tab
   /usr/share/zoneinfo/zone1970.tab
   /usr/src/cddl/contrib/opensolaris/lib/libzfs/common/libzfs_sendrecv.c
   /usr/src/contrib/tzdata/Makefile
   /usr/src/contrib/tzdata/NEWS
   /usr/src/contrib/tzdata/README
   /usr/src/contrib/tzdata/africa
   /usr/src/contrib/tzdata/antarctica
   /usr/src/contrib/tzdata/asia
   /usr/src/contrib/tzdata/australasia
   /usr/src/contrib/tzdata/backward
   /usr/src/contrib/tzdata/backzone
   /usr/src/contrib/tzdata/etcetera
   /usr/src/contrib/tzdata/europe
   /usr/src/contrib/tzdata/leap-seconds.list
   /usr/src/contrib/tzdata/leapseconds
   /usr/src/contrib/tzdata/leapseconds.awk
   /usr/src/contrib/tzdata/northamerica
   /usr/src/contrib/tzdata/southamerica
   /usr/src/contrib/tzdata/theory.html
   /usr/src/contrib/tzdata/version
   /usr/src/contrib/tzdata/ziguard.awk
   /usr/src/contrib/tzdata/zishrink.awk
   /usr/src/contrib/tzdata/zone.tab
   /usr/src/contrib/tzdata/zone1970.tab
   /usr/src/contrib/tzdata/zoneinfo2tdf.pl
   /usr/src/crypto/openssl/crypto/asn1/asn1_err.c
   /usr/src/crypto/openssl/crypto/asn1/tasn_dec.c
   /usr/src/crypto/openssl/crypto/asn1/tasn_enc.c
   /usr/src/crypto/openssl/crypto/err/openssl.txt
   /usr/src/crypto/openssl/crypto/x509v3/v3_genn.c
   /usr/src/crypto/openssl/include/openssl/asn1err.h
   /usr/src/lib/libc/sys/jail.2
   /usr/src/lib/libpam/modules/pam_login_access/login_access.c
   /usr/src/sbin/ipfw/dummynet.c
   /usr/src/sbin/ipfw/ipfw2.c
   /usr/src/sbin/ipfw/nat64lsn.c
   /usr/src/sbin/ipfw/tables.c
   /usr/src/sys/amd64/linux/linux_machdep.c
   /usr/src/sys/amd64/linux32/linux32_machdep.c
   /usr/src/sys/arm64/linux/linux_machdep.c
   /usr/src/sys/cddl/contrib/opensolaris/uts/common/sys/fs/zfs.h
   /usr/src/sys/compat/freebsd32/freebsd32_misc.c
   /usr/src/sys/conf/newvers.sh
   /usr/src/sys/dev/xen/balloon/balloon.c
   /usr/src/sys/dev/xen/blkback/blkback.c
   /usr/src/sys/dev/xen/control/control.c
   /usr/src/sys/dev/xen/xenstore/xenstore.c
   /usr/src/sys/dev/xen/xenstore/xenstore_dev.c
   /usr/src/sys/fs/autofs/autofs_vnops.c
   /usr/src/sys/fs/msdosfs/msdosfs_vnops.c
   /usr/src/sys/fs/smbfs/smbfs_io.c
   /usr/src/sys/fs/tmpfs/tmpfs_subr.c
   /usr/src/sys/i386/linux/linux_machdep.c
   /usr/src/sys/kern/kern_descrip.c
   /usr/src/sys/kern/kern_exec.c
   /usr/src/sys/kern/kern_fork.c
   /usr/src/sys/kern/kern_jail.c
   /usr/src/sys/kern/kern_timeout.c
   /usr/src/sys/kern/subr_syscall.c
   /usr/src/sys/kern/uipc_mqueue.c
   /usr/src/sys/net/if.c
   /usr/src/sys/net/if_var.h
   /usr/src/sys/netinet6/icmp6.c
   /usr/src/sys/sys/filedesc.h
   /usr/src/sys/sys/jail.h
   /usr/src/sys/x86/x86/ucode.c
   /usr/src/sys/xen/xenbus/xenbus.c
   /usr/src/sys/xen/xenbus/xenbusb.c
   /usr/src/sys/xen/xenbus/xenbusvar.h
   /usr/src/sys/xen/xenstore/xenstorevar.h
   /usr/src/usr.sbin/freebsd-update/freebsd-update.sh
   /usr/src/usr.sbin/rtsold/rtsol.c
   Installing updates...Scanning //usr/share/certs/blacklisted for certificates...
   Scanning //usr/share/certs/trusted for certificates...
    done.
   12.2-RELEASE-p4
   [00:13:50] Recording filesystem state for clean... done
   [00:13:50] Jail 12amd64 12.2-RELEASE-p4 amd64 is ready to be used

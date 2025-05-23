Result - package lists
^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ssh admin@build.example.com tree /usr/local/etc/poudriere.d/pkglist

.. literalinclude:: out/out-12.txt
   :language: bash

.. hint::

   * Use the variables ``pkdict_*.yml`` from the directory `defaults/main`_ of the role
     `vbotka.freebsd_postinstall`_. Fit the package lists to your needs.

   * Use the below variables and enable the package lists in the dictionary
     *pkglist_enable_amd64_dict*. For example, ::

       poudriere_pkglist_all: true
       pkglist_enable_amd64: "{{ pkglist_enable_amd64_dict
                                 | dict2items
                                 | selectattr('value')
                                 | map(attribute='key') }}"
     
       pkglist_enable_amd64_dict:
         ansible: true
         apache: true
         apcups: true
         devel: true
         dhcp: true
         dns: true
         docker: false
         hostap: true
         integrity: false
         jail: true
         joomla: false
         leutils: false
         linux: false
         minimal: true
         mailserver: true
         mailserver_sieve: true
         mailserver_spamassasin: true
         mcrypt: true
         mysql: true
         mysql_extra: true
         nagios: true
         nginx: true
         pf: true
         php: true
         postinstall: true
         poudriere: true
         procmail: true
         python: true
         qemu: false
         qemu_user_static: false
         roundcube: false
         roundcube_aspell: false
         rsnapshot: true
         security: true
         smart: true
         snmpd: true
         ssmtp: true
         wpa_supplicant: true
         yazvs: false

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/amd64/ansible

.. literalinclude:: out/out-13-amd64.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/amd64/minimal

.. literalinclude:: out/out-14-amd64.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/arm/ansible

.. literalinclude:: out/out-13-arm.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/arm/minimal

.. literalinclude:: out/out-14-arm.txt
   :language: bash

.. _defaults/main: https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/

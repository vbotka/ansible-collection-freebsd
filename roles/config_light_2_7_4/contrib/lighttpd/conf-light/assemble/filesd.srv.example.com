lighttpd-lighttpdconf:
  path: /usr/local/etc/lighttpd/lighttpd.conf
  create: true
  owner: root
  group: wheel
  mode: '0644'
  assignment: ' = '
  dict: "{{ cl_lighttpd_lighttpdconf_dict }}"
  handlers:
    - reload lighttpd
lighttpd_rcconf:
  path: /etc/rc.conf
  create: true
  owner: root
  group: wheel
  mode: '0644'
  assignment: '='
  dict: "{{ cl_lighttpd_rcconf_dict }}"
  handlers:
    - reload lighttpd

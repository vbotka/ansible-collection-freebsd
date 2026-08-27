lighttpd_server_document_root:
  state: directory
  path: "{{ cl_lighttpd_server_document_root }}"
  owner: "{{ cl_lighttpd_server_username }}"
  group: "{{ cl_lighttpd_server_groupname }}"
  mode: '0750'

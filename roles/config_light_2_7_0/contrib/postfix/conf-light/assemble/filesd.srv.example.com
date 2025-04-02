mailerconf:
  path: /etc/mail/mailer.conf
  template:
    path: mailer.conf.j2
    force: true
  owner: root
  group: wheel
  mode: '0644'
periodic_conf:
  path: /etc/periodic.conf
  create: true
  owner: root
  group: wheel
  mode: '0644'
  lines:
    - regexp: '^daily_clean_hoststat_enable(.*)$'
      line: 'daily_clean_hoststat_enable="{{ cl_periodicconf_daily_clean_hoststat_enable }}"'
    - regexp: '^daily_status_mail_rejects_enable(.*)$'
      line: 'daily_status_mail_rejects_enable="{{ cl_periodicconf_daily_status_mail_rejects_enable }}"'
    - regexp: '^daily_status_include_submit_mailq(.*)$'
      line: 'daily_status_include_submit_mailq="{{ cl_periodicconf_daily_status_include_submit_mailq }}"'
    - regexp: '^daily_submit_queuerun(.*)$'
      line: 'daily_submit_queuerun="{{ cl_periodicconf_daily_submit_queuerun }}"'
postfix_main_cf:
  path: /usr/local/etc/postfix/main.cf
  create: true
  owner: root
  group: wheel
  mode: '0644'
  handlers:
    - postfix_freebsd reload postfix
  lines:
    - regexp: '^myhostname\s*=\s*(.*)$'
      line: 'myhostname = {{ cl_myhostname }}'
rcconf:
  path: /etc/rc.conf
  create: true
  owner: root
  group: wheel
  mode: '0644'
  lines:
    - regexp: '^sendmail_enable(.*)$'
      line: 'sendmail_enable="{{ cl_rcconf_sendmail_enable }}"'
    - regexp: '^sendmail_submit_enable(.*)$'
      line: 'sendmail_submit_enable="{{ cl_rcconf_sendmail_submit_enable }}"'
    - regexp: '^sendmail_outbound_enable(.*)$'
      line: 'sendmail_outbound_enable="{{ cl_rcconf_sendmail_outbound_enable }}"'
    - regexp: '^sendmail_msp_queue_enable(.*)$'
      line: 'sendmail_msp_queue_enable="{{ cl_rcconf_sendmail_msp_queue_enable }}"'
    - regexp: '^postfix_enable(.*)$'
      line: 'postfix_enable="{{ cl_rcconf_postfix_enable }}"'

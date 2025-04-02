postfix:
  name: postfix
  state: "{{ cl_service_postfix_state }}"
  enabled: "{{ cl_service_postfix_enable }}"
sendmail:
  name: sendmail
  state: "{{ cl_service_sendmail_state }}"
  enabled: "{{ cl_service_sendmail_enable }}"

## Proposed FreeBSD Ansible Collection

* Ansible Galaxy: \
  [https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/)
* GitHub: \
  [https://github.com/vbotka/ansible-collection-freebsd/](https://github.com/vbotka/ansible-collection-freebsd/)
* Read The Docs: \
  [https://ansible-collection-freebsd.readthedocs.io/en/latest/](https://ansible-collection-freebsd.readthedocs.io/en/latest/)

---

## Current content of the collection

* [Plugins](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_plugins.html):
  - module iocage - iocage jail handling.
  - module service - Control or list system services.
  - module ucl - CRUD-like interface for managing UCL files.
  - inventory iocage - iocage inventory source.
  - filter iocage - Parse iocage lists.
  - lookup galaxy_info - Get the meta data from galaxy.yml
* [Roles](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_roles.html)
* [Playbooks](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_playbooks.html)

---

## Feedback from the FreeBSD DevSummit

Ansible connection plugin [jailexec](https://github.com/chofstede/ansible_jailexec) is needed
in the case there is no SSH connection to a jail.

---

## Ansible plugin jailexec

https://github.com/chofstede/ansible_jailexec

Does not work with Ansible 2.19 and later

Ansible introduced **data tagging** in version 2.19

\small

```console
PLAY [jails] *************************************************

TASK [command] ***********************************************
[ERROR]: Task failed: Configuration error for jail 'cb040eb9':
         '_AnsibleTaggedInt' object has no attribute 'strip'

fatal: [cb040eb9]: UNREACHABLE! => 
    changed: false
msg: 'Task failed: Configuration error for jail ''cb040eb9'':
     ''_AnsibleTaggedInt'' object has no attribute ''strip'''
unreachable: true
```

\normalsize

---

## Community project FreeBSD Ansible Collection

* What namespace ?
* Versions: stable, current
* Flavours: devel, minimal, ...

---

**Thank you for your attention!**

Questions ?

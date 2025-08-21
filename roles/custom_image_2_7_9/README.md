# freebsd_custom_image

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/freebsd_custom_image)
[![Build Status](https://app.travis-ci.com/vbotka/ansible-freebsd-custom-image.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-freebsd-custom-image)
[![Documentation Status](https://readthedocs.org/projects/docs/badge/?version=latest)](https://ansible-freebsd-custom-image.readthedocs.io/en/latest/)
[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-custom-image)](https://github.com/vbotka/ansible-freebsd-custom-image/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.custom_image](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_custom_image/) FreeBSD. Download, mount, and customize system images.

[Documentation at readthedocs.io](https://ansible-freebsd-custom-image.readthedocs.io)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-freebsd-custom-image/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements

### Collections

* ansible.posix
* community.general

### Roles

- [ansible_lib](https://galaxy.ansible.com/vbotka/ansible_lib)

## Notes

* By default, the role is not idempotent. At least 4 tasks will be reported changed: 1) Create
  memory disk 2) Mount mdX partitions 3) Unmount mount points 4) Detach memory disk.

* Setting `cimage_umount=false` will keep the memory disk attached and partitions mounted. This
  will make the role idempotent.

* The role doesn’t support check and diff "--check --diff"


### Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## References

- [18.9. Memory Disks - FreeBSD Handbook](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/disks-virtual.html)
- [32.3. Wireless Networking - FreeBSD Handbook](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/network-wireless.html)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)

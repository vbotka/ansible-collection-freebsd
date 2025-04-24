# rsnapshot

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/rsnapshot)
[![Build Status](https://travis-ci.org/vbotka/ansible-rsnapshot.svg?branch=master)](https://travis-ci.org/vbotka/ansible-rsnapshot)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-rsnapshot)](https://github.com/vbotka/ansible-rsnapshot/tags)

[Ansible role.](https://galaxy.ansible.com/vbotka/rsnapshot/) Install and configure [rsnapshot](http://rsnapshot.org/).

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-rsnapshot/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements and dependencies

### Roles

* vbotka.ansible_lib

### Collections

* community.general


## Role Variables

See the defaults and examples in vars.

By default there are no backup points defined by variables
**rsnapshot_backup_points** and **rsnapshot_backup_points_test**. At
least one backup point must be defined. Otherwise rsnapshot will fail
with the error:

```
ERROR: At least one backup point must be set. rsnapshot can not continue.
```

## Workflow

Install role

```sh
shell> ansible-galaxy install vbotka.rsnapshot
```

Create playbook and inventory

```sh
shell> cat rsnapshot.yml
- hosts: webserver
  roles:
    - vbotka.rsnapshot
```

Test syntax

```sh
shell> ansible-playbook rsnapshot.yml --syntax-check
```

Install packages

```sh
shell> ansible-playbook rsnapshot.yml -t rsnapshot_pkg -e rsnapshot_install=true
```

Dry-run the play and display changes

```sh
ansible-playbook rsnapshot.yml --check --diff
```

Run the play

```sh
ansible-playbook rsnapshot.yml
```

## Automatic collection of configuration variables

The list *rsnapshot_conf_vars* keeps all configuration keys of *rsnapshot.conf*
except *backup*. If you use the template

```yaml
rsnapshot_config_template: rsnapshot-auto.conf.j2
```

the tasks *tasks/vars-auto.yml*, selected from the dictionary,

```yaml
rsnapshot_config_template_vars:
  rsnapshot-auto.conf.j2: vars-auto.yml
  rsnapshot-auto-test.conf.j2: vars-auto.yml
```

collect all variables of the form *rsnapshot_\<key\>*, matching the keys from the
list *rsnapshot_conf_vars*, and create the dictionary *rsnapshot_conf_dict*. For
example,

```yaml
rsnapshot_conf_dict:
  cmd_cp: /bin/cp
  cmd_logger: /usr/bin/logger
  cmd_rm: /bin/rm
  cmd_rsync: /usr/local/bin/rsync
  cmd_ssh: /usr/bin/ssh
  config_version: '1.2'
  link_dest: '1'
  lockfile: /var/run/rsnapshot.pid
  logfile: /var/log/rsnapshot
  loglevel: '3'
  no_create_root: '0'
  retain_daily: '7'
  retain_hourly: '6'
  retain_monthly: '3'
  retain_weekly: '4'
  snapshot_root: /export/backup/snapshots
  verbose: '2'
```

The default variables *rsnapshot_\<key\>* are provided by this role for enabled
keys in the default configuration file. For example,
*/usr/local/etc/rsnapshot.conf.default* in FreeBSD. See

* OS independent variables *rsnapshot_\<key\>* in *defaults/main/conf.yml*
* OS dependent variables *rsnapshot_\<key\>* in:

  - vars/defaults/Debian.yml
  - vars/defaults/FreeBSD.yml
  - vars/defaults/RedHat.yml

The template uses the dictionary *rsnapshot_conf_dict* together with the lists
*rsnapshot_backup_points* and *rsnapshot_exclude* to create the configuration
file *rsnapshot.conf*. For example,

```bash
shell> cat /usr/local/etc/rsnapshot.conf
# Ansible managed
# rsnapshot-auto.conf.j2
# PLEASE BE AWARE OF THE FOLLOWING RULE:
# This file requires tabs between elements

cmd_cp              /bin/cp
cmd_logger          /usr/bin/logger
cmd_rm              /bin/rm
cmd_rsync           /usr/local/bin/rsync
cmd_ssh             /usr/bin/ssh
config_version      1.2
link_dest           1
lockfile            /var/run/rsnapshot.pid
logfile             /var/log/rsnapshot
loglevel            3
no_create_root      0
retain      daily   7
retain      hourly  6
retain      monthly 3
retain      weekly  4
snapshot_root       /export/backup/snapshots
verbose             2

### BACKUP POINTS/SCRIPTS
backup	/root/          localhost/
backup	/home/          localhost/
backup	/etc/           localhost/
backup	/usr/local/etc/ localhost/

### EXCLUDE
exclude	.git/
exclude	.#*
```

The same way is created *rsnapshot-test.conf* using the list
*rsnapshot_backup_points_test* and the root for testing
*rsnapshot_snapshot_root_test*.

Feel free to create your own templates, tasks vars-*.yml, and update the
dictionary *rsnapshot_config_template_vars*.

## Local customization

Put your local customization into the file *vars/main.yml*. This file is ignored
by the CVS and is preserved on updating the role.


## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)

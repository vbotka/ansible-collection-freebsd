Use cases
---------

WIP

* No root at iocage hosts.

  A user doesn't have root access at iocage host. Unprivileged access
  is sufficient to run *'iocage list ...'* and create dynamic
  inventory. This user then manages the jails with escalated privilege
  (root). See example 031.

* Root is needed at iocage hosts to list the DHCP address.

  See the options *sudo* and *sudo_preserve_env* of the inventory plugin *iocage*

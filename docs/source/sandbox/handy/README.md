# Sandbox examples running at the handy box

**Content**

001 - 899 ... docs/source/examples/ run the examples at handy box.

501 ... Configure the iocage host.

901 ... Test the filter and module vbotka.freebsd.iocage
902 ... Use ansible_port to forward the SSH connection from the iocage host to the jails.
903 ... Display iocage_ data-sets collected by the module vbotka.freebsd.iocage
904 ... Test connection plugin jailexec
905 ... Test iocage plugin syslog-ng

**Notes**

* To see the tasks timing use the 'timestamp' callback.
  shell> export ANSIBLE_STDOUT_CALLBACK=community.general.timestamp
  shell> ./bastch.sh

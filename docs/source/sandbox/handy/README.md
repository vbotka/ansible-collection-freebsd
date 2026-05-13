# Proof of concepts.

**Content**

* 001 - 899 ... docs/source/examples/ run the examples at handy box.
* 501 ... Configure the iocage host.

* 901 Test the filter and module vbotka.freebsd.iocage
* 902 Use ansible_port to forward the SSH connection from the iocage host to the jails.
* 903 Display iocage_ data-sets collected by the module vbotka.freebsd.iocage
* 904 Test connection plugin jailexec
* 905 Test ansible-pull, plugin ansible-syslogng, repo ansible-conf-syslogng-server.git
* 906 Test iocage plugin ansible-test custom facts
* 907 Test iocage plugins ansible-syslogng-client and ansible-syslogng-server (OBSOLETE)
* 908 Test var enabled_plugins; simplified version of 907
* 909 Test ansible-pull, plugin ansible-pull-test, (WIP)
* 910 Test ansible-pull, plugin ansible-pull-syslogng-server, repo ansible-conf-syslogng-server.git 
* 911 Test ansible-pull, plugin ansible-pull-syslogng-client, repo ansible-conf-syslogng-client.git
* 912 The same as 910, but the repo https://github.com/vbotka/iocage-ix-plugins (OBSOLETE)
* 913 The same as 911, but the repo https://github.com/vbotka/iocage-ix-plugins (OBSOLETE)

**Notes**

* To see the tasks timing use the 'timestamp' callback.
  shell> export ANSIBLE_STDOUT_CALLBACK=community.general.timestamp
  shell> ./batch.sh

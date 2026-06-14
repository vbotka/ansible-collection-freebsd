# Use constructed ansible_host and ansible_port

If the jails' subnet (see DHCP segment 10.1.0.0 below, attached to the jails'
bridge) is different from the local network (the iocage IP is 10.10.1.14)

shell> cat /usr/local/etc/dhcpd.conf
...
subnet 10.1.0.0 netmask 255.255.255.0 {
  range 10.1.0.100 10.1.0.200;
  option routers 10.1.0.1;
  option broadcast-address 10.1.0.255;
}

,the ssh connections to the jails can be forwarded from the jail (iocage)
host. For example, put the following redirections to /etc/pf.conf on the iocage
host

shell> cat /etc/pf/pf-rdr-ssh.conf 
...
rdr pass on $ext_if proto tcp from $localnet to any port 2200 -> 10.1.0.100 port 22
rdr pass on $ext_if proto tcp from $localnet to any port 2201 -> 10.1.0.101 port 22
rdr pass on $ext_if proto tcp from $localnet to any port 2202 -> 10.1.0.102 port 22
rdr pass on $ext_if proto tcp from $localnet to any port 2203 -> 10.1.0.103 port 22
rdr pass on $ext_if proto tcp from $localnet to any port 2204 -> 10.1.0.104 port 22
...

Then, if the IP of the iocage host is, for example, 10.10.1.14 use
the plugin constructed to create the inventory

shell> cat iocage.yml 
plugin: vbotka.freebsd.iocage
host: handy
user: admin
sudo: true
compose:
  ansible_host: "'10.10.1.14'"
  ansible_port: iocage_ip4 | split('.') | last | int - 100 + 2200

The ansible_port is the last IP octet minus 100 (because DHCP starts at 100)
plus 2200 (because the ssh forwarded ports start at 2200).

The following command connects the jail at 10.1.0.100:22

shell> ssh -p 2200 admin@10.10.1.14

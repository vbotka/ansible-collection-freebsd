# ansible_jail_name

iocage ``name`` doesn't work with ``ansible_jail_name``. iocage ``jid`` must be used.

```yaml
ansible_jail_name: iocage_jid
```

# iocage type

By default, the jails cloned from the plugins inherit the iocage property type
``pluginv2``. Change it to ``jail``

```yaml
properties:
  bpf: 1
  dhcp: 1
  vnet: 1
  notes: "vmm={{ inventory_hostname }}"
  type: jail
```

# iocage property defaultrouter

The iocage property ``defaultrouter`` may be working properly with the default (``auto``).

```console
[root@plana /home/vlado]# iocage get defaultrouter 0beb93ec-f91e-47d5-8e32-d3c4d906ec52
auto
```

```console
oot@0beb93ec-f91e-47d5-8e32-d3c4d906ec52:~ # netstat -r
Routing tables

Internet:
Destination        Gateway            Flags         Netif Expire
default            10.10.99.1         UGS         epair0b
10.10.99.0/24      link#8             U           epair0b
10.10.99.133       link#5             UHS             lo0
localhost          link#5             UH              lo0

Internet6:
Destination        Gateway            Flags         Netif Expire
::/96              link#5             URS             lo0
localhost          link#5             UHS             lo0
::ffff:0.0.0.0/96  link#5             URS             lo0
fe80::%lo0/10      link#5             URS             lo0
fe80::%lo0/64      link#5             U               lo0
fe80::1%lo0        link#5             UHS             lo0
fe80::%epair0b/64  link#8             U           epair0b
fe80::645d:86ff:fe link#5             UHS             lo0
ff02::/16          link#5             URS             lo0
```

If the default iocage option ``defaultrouter=auto`` doesn’t work set it. This may be
needed if the jails are provided with the DHCP on the bridge. In this case, the
defaultrouter for the jails is the IP address of the bridge. pf must provide NAT and
redirection. See example 440. Configure DHCP and pf. For example,

```yaml
defaultrouter: 10.10.99.1
```

See also README in example 902.

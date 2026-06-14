# iocage option defaultrouter

The iocage option ``defaultrouter`` is needed if the jails are provided with the DHCP on the
bridge. In this case, the defaultrouter for the jails is the address of the bridge. For example,

```yaml
properties:
  bpf: 1
  dhcp: 1
  vnet: 1
  notes: "vmm={{ inventory_hostname }}"
  defaultrouter: 10.10.99.1
```

pf must provide NAT and redirection. See example 440.

This is the difference between the example 203 and this example. In the example 203, DHCP is central
to the local network. NAT is simple and redirection is not needed. See the example 370.

# iocage property defaultrouter

The iocage property defaultrouter is needed if the DHCP is on the
bridge, and, as a consequence, there must be NAT both on the bridge
and the external interface. For example,

```yaml
defaultrouter: 10.10.99.1
```

See the example 902. how the network, dhcp, and pf are configured.

# Configure DHCP and pf

Added WireGuard connection via ad-hoc wlan in /etc/pf.conf

adh_if = "wlan1"

vpn_if = "wg0"
vpn_from = "172.16.97.1"
vpn_to = "172.16.97.3"
vpn_port = "51820"

pass in quick on $adh_if proto udp from $vpn_from to $vpn_to port $vpn_port keep state
pass in quick on $vpn_if proto tcp from any to any port $tcp_services flags S/SA keep state
pass in quick on $vpn_if proto tcp from any to any port $ssh_redirected_ports flags S/SA keep state
pass out quick on $vpn_if keep state

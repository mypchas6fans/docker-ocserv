#!/bin/sh

# Open ipv4 ip forward
#sysctl -w net.ipv4.ip_forward=1

# Enable NAT forwarding
iptables -t nat -A POSTROUTING -j MASQUERADE -s "${OC_IPV4_NETWORK}"/"${OC_IPV4_NETMASK}"
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# Enable TUN device
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun

# Update config
#envsubst < /tmp/ocserv.conf > /etc/ocserv/ocserv.conf
sed -i "s/example.com/$DOMAIN/g" /etc/ocserv/ocserv.conf

# Run OpennConnect Server
exec "$@"

cat > /etc/network/interfaces << EOF
# Actual wan or seperate, it just needs internet
auto eth1
iface eth1 inet static
	address 172.16.101.10/24
	gateway 172.16.101.1
# LAN 
auto eth0
iface eth0 inet static
    address 10.10.0.1/24
	post-up ip route add 10.0.1.0/24 via 10.10.0.252
	post-up ip route add 10.1.0.0/24 via 10.10.0.252
	
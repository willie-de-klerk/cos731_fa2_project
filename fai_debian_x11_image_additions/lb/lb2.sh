cat > /etc/network/interfaces << EOF
#eth0 WAN
auto eth0
iface eth0 inet static
    address 172.16.101.253/24
    gateway 172.16.101.1

#eth1 FW
auto eth1
iface eth1 inet static
    address 10.1.0.253/24

#eth2 SQL
auto eth2
iface eth2 inet static
    address 10.0.1.253/24

#eth 3
auto eth3
iface eth3 inet static
    address 10.10.0.253/24
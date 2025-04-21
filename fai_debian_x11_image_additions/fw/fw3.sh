cat > /etc/network/interfaces << EOF
auto eth0
iface eth0 inet static
    address 10.1.0.3/24
    gateway 10.1.0.252
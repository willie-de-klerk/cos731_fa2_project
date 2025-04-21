cat > /etc/network/interfaces << EOF
auto eth0
iface eth0 inet static
    address 10.0.1.1/24
    gateway 10.0.1.252

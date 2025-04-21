sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -j REJECT --reject-with icmp-host-prohibited
sudo iptables-save | sudo tee /etc/iptables/rules.v4
sudo iptables-save
cat > /etc/network/interfaces << EOF
# Actual WAN Or whaterver you want it to be
auto eth0
iface eth0 inet dhcp
	post-up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	post-up iptables-save
# LAN 
auto eth1
iface eth1 inet static
    address 172.16.101.1/24
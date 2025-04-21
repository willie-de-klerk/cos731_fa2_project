# FAI BOOT SCRIPTS

Created to run on first boot of the generated images, made with the **[fai project](https://fai-project.org/FAIme/)**. 

# How to make your own images with the scripts: 
## Toggle Advanced on the fai-me page

<ul>
<li>Distribution: Debian 12 Bookworm (stable)</li>
<li>Which Desktop to Install: Plain text console, no x11</li>
<li>Custom script to put into /usr/local/bin/: Upload the script for the vm, eg. fw1.sh</li>
<li>**Select Reboot computer after installation**</li>
</ul>

For all images, select the following additional software:
<ul>
<li>Web Server (If Frontend Web VM)</li>
<li>Openssh server</li>
<li>Standard system tools</li>
<li>Non-free Linux Firmware</li>
<ul>


## Forntend Web Scripts
<ul>
<li><a href="./fw/fw1.sh"> Frontend Web 1</a></li>
<li><a href="./fw/fw2.sh"> Frontend Web 1</a></li>
<li><a href="./fw/fw3.sh"> Frontend Web 1</a></li>
<li><a href="./fw/fw4.sh"> Frontend Web 1</a></li>
</ul>

# Scripts 
## Load Balancer Scripts
*Please add iptables as a package and enable recommended packages for the package list*
<ul>
 <li><a href="./lb/lb1.sh">Load balancer 1</a></li>
  <li><a href="./lb/lb2.sh">Load balancer 2</a></li>
</ul>

## SQL VM Script
<ul>
  <li><a href="./sql/sql1.sh">SQL VM Script</a></li>
</ul>

## Wan Router Script
*Please add iptables as a package and enable recommended packages for the package list*
<ul>
  <li><a href="./wan_router.sh"></a></li>
</ul>


## Ansible Management VM Script
<ul>
  <li><a href="./mgmnt/mgmnt.sh"></a></li>
</ul>
#!/bin/sh

WLAN_DEV="wlan0"
WLAN_IP="192.168.45.123"

modprobe b43 qos=0

ifconfig $WLAN_DEV $WLAN_IP
iwconfig $WLAN_DEV txpower 20dBm

echo 1 > /proc/sys/net/ipv4/ip_forward
touch /var/lock/subsys/local
modprobe ip_nat_ftp
modprobe ip_conntrack_ftp
iptables -t nat -A POSTROUTING -s $WLAN_IP/24 -d 0/0 -o eth0 -j MASQUERADE

/etc/rc.d/rc.hostapd restart

/etc/rc.d/rc.dhcpd restart 2> /dev/null

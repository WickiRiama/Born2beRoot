#!/bin/bash
arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free --mega | awk '$1 == "Mem:" {print $2}')
uram=$(free --mega | awk '$1 == "Mem:" {print $3}')
pram=$(free --mega| awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -H --total | grep '^total' | awk '{print $2}')
udisk=$(df -H --total | grep '^total' | awk '{print $3}')
pdisk=$(df -H --total | grep '^total' | awk '{print $5}')
cpul=$(top -bn1 | grep '^%Cpu' | awk -F "ni," '{print $2}' | awk -F " id," '{print 100 - $1}')
lb=$(who -b | awk '{print $3 " " $4}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(ss -Ht state established | wc -l)
ulog=$(who | cut -d " " -f 1 | sort -u | wc -l)
ip=$(hostname -I)
mac=$(ip addr | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l) 
wall "	#Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $udisk/${fdisk} ($pdisk)
	#CPU load: $cpul%
	#Last boot: $lb
	#LVM use: $lvmu
	#Connexions TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd"

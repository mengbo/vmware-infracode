#!/bin/bash

# Install vmware-tools
yum install open-vm-tools perl

# Enable customization scripts
vmware-toolbox-cmd config set deployPkg enable-custom-scripts true


# Clean yum cache
yum clean all

# Stop logging service
/usr/bin/systemctl stop rsyslog

# Force logrotate to shrink logspace and remove old logs as well as truncate logs
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

# Remove udev hardware rules
/bin/rm -f /etc/udev/rules.d/70*

# Remove uuid from ifcfg scripts
/bin/cat > /etc/sysconfig/network-scripts/ifcfg-ens192 <<EOF
DEVICE=ens192
ONBOOT=yes
EOF

# Remove SSH host keys
/bin/rm -f /etc/ssh/*key*

# Remove root users shell history
/bin/rm -f /root/.bash_history
unset HISTFILE

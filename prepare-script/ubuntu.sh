#!/bin/bash

# Install vmware-tools
apt install open-vm-tools perl

# Disable cloud-init
touch /etc/cloud/cloud-init.disabled

# Enable customization scripts
vmware-toolbox-cmd config set deployPkg enable-custom-scripts true


# Clean apt cache
apt clean

# Stop logging service
service rsyslog stop

# Clear logs
if [ -f /var/log/audit/audit.log ]; then
    cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    cat /dev/null > /var/log/lastlog
fi

# Remove persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
fi

# Cleanup /tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

# Remove ssh host keys
rm -f /etc/ssh/ssh_host_*

# Add check for ssh keys on reboot...regenerate if neccessary
cat << EOL | sudo tee /etc/rc.local
#!/bin/sh -e

test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL
chmod +x /etc/rc.local

# Reset hostname
cat /dev/null > /etc/hostname

# Remove root users shell history
/bin/rm -f /root/.bash_history
unset HISTFILE

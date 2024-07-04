#!/usr/bin/bash
if [ ! -f /var/setup_vm ]; then
    curl 169.254.169.254/latest/user-data | tr -d '\r' |sh -x  2>&1 > /var/log/setup_vm.log
    touch /var/setup_vm 
fi
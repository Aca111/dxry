#!/bin/sh

#starting nginx 

#nginx -g "daemon off;" & > /dev/null

# starting xray-core

#/usr/sbin/sshd
/usr/bin/shellinaboxd -t
x-ui start
netstat -tuplen
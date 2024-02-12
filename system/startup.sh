#!/bin/sh
set -e
ssh-keygen -A
#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

echo "Starting SSH ..."
service ssh start

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.ini
exec "$@"
#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')

VERISON=4.35.18
DATE=20230416

fetch https://github.com/Thefrank/freebsd-port-sooners/releases/download/${DATE}/ombi-${VERISON}.pkg

# need to manual create ombi user. new pkg broken?
pw adduser ombi -g ombi -d /nonexistent -s /usr/sbin/nologin -c "Ombi Daemon" -u 363

pkg install -y ombi-${VERISON}.pkg
rm ombi-${VERISON}.pkg

ln -s /usr/local/lib/libsqlite3.so /usr/local/lib/libe_sqlite3

sysrc ombi_enable=TRUE

service ombi restart 2>/dev/null

echo -e "obmi now installed.\n" > /root/PLUGIN_INFO
echo -e "\nPlease open your web browser and go to http://${IP_ADDRESS}:5000 to configure ombi.\n" >> /root/PLUGIN_INFO

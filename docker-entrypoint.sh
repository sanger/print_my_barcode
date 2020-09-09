#!/bin/bash
mkdir /etc/cups/
echo "ServerName $CUPSD_SERVER_NAME" > /etc/cups/client.conf
if [ $CUPSD_UPDATE == "true" ]
then
    bundle exec rails printers:create
fi
exec "$@"
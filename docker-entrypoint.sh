#!/bin/bash
mkdir /etc/cups/
echo "ServerName $CUPSD_SERVER_NAME" > /etc/cups/client.conf
if [ $CUPSD_UPDATE == "true" ]
then
    echo "-> Printing printer names here:"
    bundle exec rails runner "puts Printer.all.map(&:name)"
    echo "-> Running printers rake task"
    bundle exec rails printers:create
    echo "-> Printers rake task complete"
fi
exec "$@"
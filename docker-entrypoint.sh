#!/bin/bash
mkdir /etc/cups/
echo "ServerName $CUPSD_SERVER_NAME" > /etc/cups/client.conf
TIMEOUT=120
CUPSPORT=631
CUPSHOST=cupsd
if [[ $CUPSD_UPDATE == "true" ]]
then
    echo "-> Waiting for cups to become available"
    bash ./wait_for_connection.sh "${CUPSHOST}" "${CUPSPORT}" "${TIMEOUT}"
    echo "-> Running printers rake task"
    bundle exec rails printers:create
    echo "-> Printers rake task complete"
fi
exec "$@"
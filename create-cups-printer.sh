#!/usr/bin/expect
set printername [lindex $argv 0];
spawn lpadmin -U "$env(CUPSD_USERNAME)" -p $printername -v socket://$printername.psd.sanger.ac.uk -E
expect "Password for $env(CUPSD_USERNAME) on cupsd?"
send -- "$env(CUPSD_PASSWORD)\n"
expect eof
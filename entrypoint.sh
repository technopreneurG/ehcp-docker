#!/bin/sh

## By: GirishN

# A monolith entrypoint script which knows 
# how to start EHCP and related services


check_standalone_mode()
{
  # Return 1 if vsftpd.conf doesn't have listen yes or listen_ipv6=yes
  CONFFILE="/etc/vsftpd.conf"

  if [ -e  "${CONFFILE}" ] && ! egrep -iq "^ *listen(_ipv6)? *= *yes" "${CONFFILE}"
  then
    echo "${CONFFILE}: listen disabled - service will not start"
    return 1
  fi 
}

[ -d /var/run/vsftpd ] || install -m 755 -o root -g root -d /var/run/vsftpd
[ -d /var/run/vsftpd/empty ] || install -m 755 -o root -g root -d /var/run/vsftpd/empty

check_standalone_mode || stop


#Replace the email id
grep -rl my_ehcp_setup_AT_admin_email.com ./ | xargs -I% sed --in-place=.bkp -e "s/my_ehcp_setup_AT_admin_email.com/$ADMIN_EMAIL/" %

rsyslogd

service courier-authdaemon start
service mysql start
service apache2 start
service bind9 start
service courier-imap start
service courier-imap-ssl start
service fail2ban start
service php5-fpm start
service postfix start
service quota start
service sendmail start
service sysstat start
service ehcp start

/usr/sbin/vsftpd /etc/vsftpd.conf

exec "$@"

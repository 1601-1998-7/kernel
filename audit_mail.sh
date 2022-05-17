hostName=`hostname`

SUBJECT="Testing mail whether sbin/sendmail works in  $hostName"

        MSG=`echo "Hi Team. This is an automated message from Aadi"`

             /usr/sbin/sendmail -C /etc/mail/sendmail.cf  -f aadithya.t@zohocorp.com -t aadithya.t@zohocorp.com,relevant-teams@zohocorp.com <<END

SUBJECT:$SUBJECT

$MSG

END


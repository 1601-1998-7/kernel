hostName=`hostname`

SUBJECT="Testing mail whether sbin/sendmail works in  $hostName"

        MSG=`echo "Hi Team. This is an automated message from Aadi"`

             /usr/sbin/sendmail -C /etc/mail/sendmail.cf  -f aadithya.t@company.com -t aadithya.t@company.com,relevant-teams@company.com <<END

SUBJECT:$SUBJECT

$MSG

END


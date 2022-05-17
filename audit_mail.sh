hostName=`hostname`

SUBJECT="Testing mail whether sbin/sendmail works in  $hostName"

        MSG=`echo "Hi Arul. This is an automated message from Aadi"`

             /usr/sbin/sendmail -C /etc/mail/sendmail.cf  -f aadithya.t@zohocorp.com -t aadithya.t@zohocorp.com,arulbalan.ac@zohocorp.com <<END

SUBJECT:$SUBJECT

$MSG

END


#!/bin/bash
# a script that show how many new mails you got
# to use it in xmobar add this
# Run Com "sh" ["/path/to/mail.sh"] 20

source ~/.mailconf

dane="$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
https://${gmail_login}:${gmail_password}@mail.google.com/mail/feed/atom \
--no-check-certificate | grep 'fullcount' \
| sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//' 2>/dev/null)"

if [ -z "$dane" ]; then
    echo ""
else
    echo "$dane"
fi

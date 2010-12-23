#!/bin/zsh
# a script that show how many new mails you got
# to use it in xmobar add this
# Run Com "sh" ["/path/to/mail.sh"] 20

#gmail_users
typeset -A mailconf
source ~/.config/mailconf

for un in ${(k)mailconf}; do
    if [[ "$un" =~ [^@]+$ ]]; then
        if [ "$MATCH" != "gmail.com" ]; then
            domain="https://mail.google.com/a/$MATCH/feed/atom"
        else
            domain="https://mail.google.com/mail/feed/atom"
        fi
    else
        echo "$un is not a valid email address!"
        continue
    fi
    pw=${mailconf[$un]}
    authresp=`curl --silent https://www.google.com/accounts/ClientLogin --data-urlencode "Email=$un" --data-urlencode "Passwd=$pw" --data-urlencode "accountType=HOSTED_OR_GOOGLE" --data-urlencode "source=xmobar-mail" --data-urlencode "service=mail"`
    if [[ "$authresp" =~ uth=.*$ ]]; then
        echo $MATCH
        dataresp=`curl --silent --header "Authorization: GoogleLogin a$MATCH" "$domain"`
        echo $dataresp
    else
        echo "No auth token received (bad username/password?)"
    fi
done


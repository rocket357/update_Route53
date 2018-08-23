#!/bin/sh
#set -x

### UPDATE THESE
HOSTNAME='myrouter.mydomain.com'
HOSTEDZONE='myhostedzoneID'

### NO NEED TO EDIT BELOW THIS LINE
function update {
       logger "Route53 UPDATE:  ${1} -> ${2}"
       # location of a virtualenv with awscli configured with Route53 permissions
       . $HOME/awscli/bin/activate 
       cat << _EOF > /tmp/${1}
       {
         "Changes": [
           {
             "Action": "UPSERT",
             "ResourceRecordSet": {
               "Name": "${1}",
               "Type": "A",
               "TTL": 60,
               "ResourceRecords": [
                 {
                   "Value": "${2}"
                 }
               ]
             }
           }
         ]
       }
_EOF
       aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE --change-batch file:///tmp/${1}
       rm /tmp/${1}
}

# check that the old ip exists
[ -f $HOME/old_ip ] && export old_ip=$(cat $HOME/old_ip) || export old_ip='X'
# use myip.opendns.com to pull your current IP address
myip=$(dig +short @208.67.222.222 myip.opendns.com)
# update the old ip file
[ -z $myip ] || echo $myip > $HOME/old_ip
# check that the new ip and old ip match, if not, update Route53
[ $myip = $old_ip ] || update $HOSTNAME $myip


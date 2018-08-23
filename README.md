### Route53 Update script

This script updates a dns record hosted in a Route53 hosted zone.  It is intended for
updating a dns record that stores a dynamically assigned IP, such as for a residential
IP via Comcast.  This is useful, for instance, if your modem is set up for passthrough,
or you are using a "dumb" modem that passes DHCP requests through, such that your
router has the public IP address assigned to its WAN interface.

For more information about setting up a Route53 hosted zone, see:

https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html

Once you have a public hosted zone set up, you'll need to adjust the update_r53.sh
script with your information (variables 'HOSTNAME' and 'HOSTEDZONE').  After that,
setting the script up to run in a cronjob will check your ip and update it, if needed,
on the interval the cronjob is set for.

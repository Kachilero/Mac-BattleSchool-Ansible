#Assumed...

* SSH keys already set and accepted on servers

##steps

1. Download zip to Downloads directory
2. Run `sh start.sh`
3. Follow promts, the MAMP prompts are the only slightly tricky ones. On MAMP before you start the servers go into preferences and change PHP to PHP 5.4 if running drupal 7.


##TODO:
* Setup cron job for auto-git.php
* Mamp keeps updating, need to just grab latest
* make more moduler

## Known issues:
* dnsmasq doesn't always get setup right. how to tell
`ping mysite.dev` if it doesn't return `127.0.0.1` it failed. Manually run this:
```
sudo mkdir /etc/resolver;
sudo touch /etc/resolver/dev;
sudo echo 'nameserver 127.0.0.1' > /etc/resolver/dev;
```
if you continue to have issues read this [blog](http://passingcuriosity.com/2013/dnsmasq-dev-osx/)
* It sometimes randomly fails, not sure why yet. Just run it again and it's all good.

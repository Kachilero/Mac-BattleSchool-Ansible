#!/bin/bash/
echo 'address=/.dev/127.0.0.1' > /usr/local/etc/dnsmasq.conf;
brew update;
brew install php55;
brew install php55-intl;
brew install homebrew/php/composer;
brew install --HEAD drush;
brew switch drush HEAD;
cd /usr/local/Cellar/drush/HEAD/libexec;
composer install;
cd /Applications/MAMP/conf/apache;
cp ~/.battleschool/httpd.conf .;
cp ~/.battleschool/extra-httpd-vhosts.conf ./extra/httpd-vhosts.conf;
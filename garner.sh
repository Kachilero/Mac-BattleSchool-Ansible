mkdir ~/.battleschool;

# move everything to .battleschool directory
echo 'moving everything to the battleschool directory';
cp -R ~/Downloads/Mac-BattleSchool-Ansible-master/* ~/.battleschool/;
cd ~/.battleschool;
#config dnmasq
brew install dnsmasq;
echo 'config dnsmasq';
cp $(brew list dnsmasq | grep /dnsmasq.conf.example$) /usr/local/etc/dnsmasq.conf;
sudo cp $(brew list dnsmasq | grep /homebrew.mxcl.dnsmasq.plist$) /Library/LaunchDaemons/;
sudo echo 'address=/.dev/127.0.0.1' > /usr/local/etc/dnsmasq.conf;
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist;
sudo echo 'nameserver 127.0.0.1' > /etc/resolver/dev;

echo 'configure mamp';
cd /usr/local/bin; sudo ln -s /Applications/MAMP/Library/bin/mysql mysql;
cd /Applications/MAMP/conf/apache;
cp ~/.battleschool/httpd.conf .;
cp ~/.battleschool/php.ini /Applications/MAMP/conf/php5.4.30/php.ini;
cp ~/.battleschool/php.ini /Applications/MAMP/bin/php/php5.4.30/conf/php.ini;
cp ~/.battleschool/my.cnf /Applications/MAMP/conf/my.cnf;
rm -R /Applications/MAMP/bin/php/php5.1.6;
rm -R /Applications/MAMP/bin/php/php5.2.17;
rm -R /Applications/MAMP/bin/php/php5.3.28;
rm /Applications/MAMP/db/mysql/ib_logfile0;
rm /Applications/MAMP/db/mysql/ib_logfile1;
#build virtual hosts
if [ ! -f /Applications/MAMP/conf/apache/extra/ran-script.txt ]; then
    #we don't want to keep appending this onto the end, that probably does bad things
    echo '<VirtualHost *:80>
      VirtualDocumentRoot /Users/'"$UserName"'/Sites/%1
      ServerAdmin webmaster@local.local
      ServerName locals.dev
      ServerAlias *.dev
      ErrorLog "logs/dynamic-error.local"
      CustomLog "logs/dynamic.local" common
    </VirtualHost>
    <VirtualHost *:80>
        VirtualDocumentRoot /Users/'"$UserName"'/Sites/%1
        ServerAdmin webmaster@local.local
        ServerName xip.io
        ServerAlias *.xip.io
        ErrorLog "logs/xip-dynamic-error.local"
        CustomLog "logs/xip-dynamic.local" common
    </VirtualHost>' >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf;
    touch /Applications/MAMP/conf/apache/extra/ran-script.txt;
fi

# set up autogit drush
# if you aren't in Code Koalas, then you don't have this and can skip this
# our auto-git code is pretty clever
# if a new drush alias is made and pushed up, 
# the site auto downloads on every computer
# so people can 'instantly' start local development with no setup
# it's basically magic

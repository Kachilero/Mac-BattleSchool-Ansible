#Assumed...

* already installed MAMP (and it's currently running)
* SSH keys already set and accepted on servers

##steps
```
sudo easy_install pip;
sudo pip install battleschool;
mkdir ~/.battleschool;
cd ~/.battleschool;
git clone https://github.com/fabean/Mac-BattleSchool-Ansible.git;
battle --config-file ~/.battleschool/config.yml --module-path=/usr/share/battleschool/library --ask-sudo-pass;
cd playbooks;
sh dnsmasq.sh;
```

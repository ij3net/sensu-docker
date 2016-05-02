#!/bin/bash
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list

apt-get update && apt-get install -y git-core sensu
echo "sensu hold" | dpkg --set-selections

cat << EOF > /etc/default/sensu
EMBEDDED_RUBY=true
LOG_LEVEL=info
EOF
ln -sf /opt/sensu/embedded/bin/ruby /usr/bin/ruby
/opt/sensu/embedded/bin/gem install redphone --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install mail --no-rdoc --no-ri --version 2.5.4
/opt/sensu/embedded/bin/gem install bunny --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugin --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-cpu-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-load-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-php-fpm --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-mailer --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-influxdb --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-telegram --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-load-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-memory-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-nginx --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-mysql --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-disk-checks --no-rdoc --no-ri

find /etc/sensu/plugins/ -name *.rb -exec chmod +x {} \;

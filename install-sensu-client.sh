#!/bin/bash
wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list

apt-get update && apt-get install -y git-core sensu build-essential
echo "sensu hold" | dpkg --set-selections

cat << EOF > /etc/default/sensu
EMBEDDED_RUBY=true
LOG_LEVEL=info
EOF
ln -sf /opt/sensu/embedded/bin/ruby /usr/bin/ruby
/opt/sensu/embedded/bin/gem install redphone --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install mail --no-rdoc --no-ri --version 2.5.4
/opt/sensu/embedded/bin/gem install bunny --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install vmstat --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugin --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-cpu-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-load-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-php-fpm --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-load-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-memory-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-nginx --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-mysql --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-disk-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-redis --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-process-checks --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-http --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-memcached --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-elasticsearch --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem install sensu-plugins-ssl --no-rdoc --no-ri
/opt/sensu/embedded/bin/gem sensu-plugins-network-checks --no-rdoc --no-ri
sudo mkdir -p /etc/sensu/ssl && sudo cp /tmp/cert.pem /tmp/key.pem /etc/sensu/ssl
cat << EOF > /etc/sensu/conf.d/rabbitmq.json
{
  "rabbitmq": {
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    },
    "host": "sensu.cloud-ops.tk",
    "port": 5671,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "pass"
  }
}
EOF
cat << EOF > /etc/sensu/conf.d/client.json
{
  "client": {
    "name": "client1",
    "address": "localhost",
    "subscriptions": [ "system" ]
  }
}
EOF
sudo update-rc.d sensu-client defaults
sudo service sensu-client stop
joe /etc/sensu/conf.d/client.json
sudo service sensu-client start

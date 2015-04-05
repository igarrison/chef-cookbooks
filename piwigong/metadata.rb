name             "piwigong"
maintainer       "Ian Garrison"
maintainer_email "garrison@technoendo.net"
license          "Apache 2.0"
description      "Installs/Configures Piwigo Web Gallery"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "httpd" '~> 0.2'
depends "mysql" '~> 6.0'
#depends "php"
#depends "apache2"
#depends "mysql"
#depends "openssl"
depends "database" '~> 4.0'
#depends "apt"
#depends "chef-vault"
#depends "opscode-backup"

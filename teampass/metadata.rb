maintainer       "Ian Garrison"
maintainer_email "garrison@technoendo.net"
license          "Apache 2.0"
description      "Installs/Configures teampass a collaborative password management site http://www.teampass.net/"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.0"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "php"
depends "apache2"
depends "mysql"
depends "openssl"
depends "database"
depends "git"
depends "chef-vault"

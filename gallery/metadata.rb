name             "gallery"
maintainer       "Ian Garrison"
maintainer_email "garrison@technoendo.net"
license          "Apache 2.0"
description      "Installs/Configures gallery 3"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "php"
depends "apache2"
depends "mysql"
depends "openssl"
depends "database"
depends "git"
depends "ark"
depends "certificate"

name             'snekmon'
maintainer       'Ian Garrison'
maintainer_email 'garrison@technoendo.net'
license          'Apache 2.0'
description      'Installs/Configures snekmon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'debian'
supports 'ubuntu'

depends "git"
depends "runit"
depends "cron"

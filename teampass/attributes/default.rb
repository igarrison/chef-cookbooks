default[:teampass][:version] = "2.1.19"
default[:teampass][:gitrepo] = "git://github.com/nilsteampassnet/TeamPass.git"
default[:teampass][:dir] = "/var/www/teampass"
default[:teampass][:backup_dir] = "/var/backups/teampass"
default[:teampass][:backup_schedule] = "0 23 * * *"

default[:teampass][:database_mysql] = true
default[:teampass][:dbname] = "teampassdb"
default[:teampass][:dbuser] = "teampassadmin"
default[:teampass][:dbhost] = "localhost"
::Chef::Node.send(:include, Opscode::OpenSSL::Password)
set_unless[:teampass][:dbpass] = secure_password

default[:teampass][:webserver_apache2] = true
default[:teampass][:usechefvault] = true
default[:teampass][:email] = "postmaster@example.com"
default[:teampass][:wwwhostname] = "teampass.example.com"
default[:teampass][:apachessl] = false
default[:teampass][:sslcertdir] = "/etc/apache2/ssl"
default[:teampass][:sslcertmode] = "wildcard"

case node[:teampass][:sslcertmode]
when "wwwhostname"
  default[:teampass][:vaultitem] = "sslcert-#{node[:teampass][:wwwhostname]}"
  default[:teampass][:sslcertfile] = "#{node[:teampass][:sslcertdir]}/#{node[:teampass][:wwwhostname]}.pem"
  default[:teampass][:sslkeyfile] = "#{node[:teampass][:sslcertdir]}/#{node[:teampass][:wwwhostname]}.key"
  default[:teampass][:sslchainfile] = "#{node[:teampass][:sslcertdir]}/CAcert.crt"
when "wildcard"
  default[:teampass][:vaultitem] = "selfsigned_wildcard_ssl_cert"
  default[:teampass][:sslcertfile] = "#{node[:teampass][:sslcertdir]}/selfsigned_wildcard.pem"
  default[:teampass][:sslkeyfile] = "#{node[:teampass][:sslcertdir]}/selfsigned_wildcard.key"
  default[:teampass][:sslchainfile] = "#{node[:teampass][:sslcertdir]}/selfsigned_wildcard_cacert.pem"
end

# Database
#default[:piwigo][:dbname] = "piwigodb"
#default[:piwigo][:dbuser] = "piwigouser"
#default[:piwigo][:dbhost] = "localhost"
#default[:piwigo][:dbrole] = "mysql-master"
#default[:piwigo][:uselocalmysqld] = true

# Web + SSL
default[:piwigo][:wwwname] = "piwigo.example.com"
default[:piwigo][:wwwdir] = "/var/www/piwigo"
default[:piwigo][:adminemail] = "postmaster@example.com"
#default[:piwigo][:webserver_apache2] = true
default[:piwigo][:apachessl] = false
#default[:piwigo][:sslcertmode] = "wildcard"
default[:piwigo][:log_dir] = "/var/log/piwigo"

#case node[:piwigo][:sslcertmode]
#when "wwwhostname"
#  default[:piwigo][:vaultitem] = "sslcert-#{node[:piwigo][:wwwname]}"
#  default[:piwigo][:sslcertfile] = "/etc/ssl/certs/#{node[:fqdn]}.pem"
#  default[:piwigo][:sslkeyfile] = "/etc/ssl/private/#{node[:fqdn]}.key"
#  default[:piwigo][:sslchainfile] = "/etc/ssl/certs/#{node[:hostname]}-bundle.crt"
#when "wildcard"
#  default[:piwigo][:vaultitem] = "selfsigned_wildcard_ssl_cert"
#  default[:piwigo][:sslcertfile] = "/etc/ssl/certs/wildcard.pem"
#  default[:piwigo][:sslkeyfile] = "/etc/ssl/private/wildcard.key"
#  default[:piwigo][:sslchainfile] = "/etc/ssl/certs/wildcard-bundle.crt"
#end

# Core and Contrib
default[:piwigo][:version] = "2.7.3"
default[:piwigo][:zipurl] = "http://piwigo.org/download/dlcounter.php?code=2.7.1"

#default[:piwigo][:backup_dir] = "/var/backups/piwigo"
#default[:piwigo][:backup_schedule] = "05 23 * 1 *"
#default[:piwigo][:usechefvault] = true

# PHP Directives Related To Image/File Uploads
#default[:piwigo][:php][:upload_max_filesize] = "400M"
#default[:piwigo][:php][:memory_limit] = "512M"
#default[:piwigo][:php][:post_max_size] = "400M"
#default[:piwigo][:php][:max_file_uploads] = 25

# Auto Generated Passwords stored in Node Data
#::Chef::Node.send(:include, Opscode::OpenSSL::Password)
#set_unless[:piwigo][:dbpass] = secure_password
#set_unless[:piwigo][:adminpass] = secure_password

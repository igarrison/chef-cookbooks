# Database
default[:gallery][:dbname] = "gallerydb"
default[:gallery][:dbuser] = "galleryuser"
default[:gallery][:dbhost] = "localhost"
default[:gallery][:dbrole] = "mysql-master"
default[:gallery][:uselocalmysqld] = true

# Web + SSL
default[:gallery][:wwwname] = "gallery3.example.com"
default[:gallery][:wwwdir] = "/var/www/gallery"
default[:gallery][:adminemail] = "postmaster@example.com"
default[:gallery][:webserver_apache2] = true
default[:gallery][:apachessl] = false
# sslcertmode = default, wildcard, or manage_by_attributes as defined in cookbook:certificates, and "none" for no certificate management.  You will need to setup encrypted data bags and read up on http://community.opscode.com/cookbooks/certificate if you use any mode other than none
default[:gallery][:sslcertmode] = "none"

case node[:gallery][:sslcertmode]
when "default", "managed_by_attributes", "none"
  default[:gallery][:sslcertfile] = "/etc/ssl/certs/#{node[:fqdn]}.pem"
  default[:gallery][:sslkeyfile] = "/etc/ssl/private/#{node[:fqdn]}.key"
  default[:gallery][:sslchainfile] = "/etc/ssl/certs/#{node[:hostname]}-bundle.crt"
when "wildcard"
  default[:gallery][:sslcertfile] = "/etc/ssl/certs/wildcard.pem"
  default[:gallery][:sslkeyfile] = "/etc/ssl/private/wildcard.key"
  default[:gallery][:sslchainfile] = "/etc/ssl/certs/wildcard-bundle.crt"
end

# Install Core and Contrib Files
default[:gallery][:gitinstall] = true
default[:gallery][:version] = "3.0.9"
default[:gallery][:gitrepo] = "git://github.com/gallery/gallery3.git"
default[:gallery][:zipurl] = "https://github.com/gallery/gallery3/archive/3.0.x.zip"
default[:gallery][:contribzipurl] = "https://github.com/gallery/gallery3-contrib/archive/master.zip"
default[:gallery][:gitcontribrepo] = "git://github.com/gallery/gallery3-contrib.git"

# PHP Directives Related To Image/File Uploads
default[:gallery][:php][:upload_max_filesize] = "256M"
default[:gallery][:php][:memory_limit] = "512M"
default[:gallery][:php][:post_max_size] = "256M"
default[:gallery][:php][:max_file_uploads] = 25

# Auto Generated Passwords stored in Node Data
::Chef::Node.send(:include, Opscode::OpenSSL::Password)
set_unless[:gallery][:dbpass] = secure_password
set_unless[:gallery][:adminpass] = secure_password

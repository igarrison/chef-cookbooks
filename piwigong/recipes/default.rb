#
# Cookbook Name:: piwigo
# Recipe:: default

# openssl is used to generate random passwords
#include_recipe "openssl"

directory node[:piwigo][:wwwdir] do
  mode "0755"
  action :create
  recursive true
end

directory node[:piwigo][:log_dir] do
  mode "0750"
  user "root"
  group "adm"
  action :create
  recursive true
end

execute 'first-time-run-apt-get-update' do
  command "apt-get update"
  ignore_failure true
  not_if { File.exists?("#{node[:piwigo][:wwwdir]}/ftr-#{node[:piwigo][:version]}") }
end

file "#{node[:piwigo][:wwwdir]}/ftr-#{node[:piwigo][:version]}" do
  action :create_if_missing
  content "# This file created by chef by #{cookbook_name}::#{recipe_name}"
  #not_if { File.exists?("#{node[:piwigo][:wwwdir]}/ftr-#{node[:piwigo][:version]}") }
end

# php5-mysql is needed yes?
%w[imagemagick mediainfo unzip libapache2-mod-php5 php5-mysql php5-ldap].each do |packagedep|
  package packagedep
end

link "#{node[:piwigo][:wwwdir]}/current" do
  to "piwigo-#{node[:piwigo][:version]}/piwigo"
  not_if { ::File.symlink?"#{node[:piwigo][:wwwdir]}/current" }
end

httpd_service 'default' do
  mpm "prefork"
  action [:create, :start]
end

httpd_config 'default' do
  source 'piwigo-apache.conf.erb'
  notifies :restart, 'httpd_service[default]'
  action :create
end

#%w[ldap php5].each do |httpdmodules|
#  httpd_module httpdmodules do
#    action :create
#  end
#end

httpd_module "ldap"
httpd_module "php5"

link "#{node[:piwigo][:wwwdir]}/current" do
  to "piwigo-#{node[:piwigo][:version]}"
  not_if { ::File.symlink?"#{node[:piwigo][:wwwdir]}/current" }
end

if node[:piwigo][:apachessl]
  http_module 'ssl'
  httpd_module 'rewrite'
end

mysql_service 'default' do
  port '3306'
  version '5.6'
  initial_root_password node[:piwigo][:dbrootpass]
  #initial_root_password 'changeme'
  action [:create, :start]
end

template "/root/.mysql-default.my.cnf" do
  source "mysql-my.cnf.erb"
  mode "0600"
  owner "root"
  group "root"
  backup false
  #action :nothing
  sensitive true
end
#end.run_action(:create)

# this symlink is needed to get /usr/bin/mysqladmin usable with a 
link '/var/run/mysqld/mysqld.sock' do
  to '/run/mysql-default/mysqld.sock'
  not_if { ::File.symlink?'/var/run/mysqld/mysqld.sock' }
end

#Chef::Log.info("DEBUG: #{node[:piwigo][:dbname]}")
#Chef::Log.info("DEBUG: #{node[:piwigo][:dbhost]}")
#Chef::Log.info("DEBUG: /usr/bin/mysqladmin --defaults-extra-file=/root/.mysql-default.my.cnf --socket=/run/mysql-default/mysqld.sock -u root -h #{node[:piwigo][:dbhost]} create #{node[:piwigo][:dbname]}")

execute "create piwigo database in mysql" do
  command "/usr/bin/mysqladmin --defaults-extra-file=/root/.mysql-default.my.cnf --socket=/run/mysql-default/mysqld.sock -u root -h #{node[:piwigo][:dbhost]} create #{node[:piwigo][:dbname]}"
  not_if "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf --socket=/run/mysql-default/mysqld.sock -u root -r -B -e 'show databases' | grep #{node[:piwigo][:dbname]}"
end

template "/etc/mysql-default/piwigo-grants.sql" do
  source "piwigo-mysql-grants.sql.erb"
  mode "0600"
  owner "root"
  group "root"
  backup false
  sensitive true
end

execute "install piwigo user grants into mysql" do
  command "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf --socket=/run/mysql-default/mysqld.sock -u root -h #{node[:piwigo][:dbhost]} < /etc/mysql-default/piwigo-grants.sql"
  not_if "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf --socket=/run/mysql-default/mysqld.sock -u root -D mysql -r -B -N -e \"SELECT User FROM user WHERE User = \'#{node[:piwigo][:dbuser]}\'\" | grep #{node[:piwigo][:dbuser]}"
end

#%w[libmysqlclient-dev ruby2.0-dev build-essential].each do |packagedep|
#  package packagedep
#end

#chef_gem 'mysql2' do
#  action :install
#end

#mysql_config 'default' do
#  source 'piwigo.cnf.erb'
#  notifies :restart, 'mysql_service[default]'
#  action :create
#end

remote_file "#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}.zip" do
  source node[:piwigo][:zipurl]
  mode "0644"
  not_if { File.exists?("#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}.zip") } 
end

execute 'unzip-piwigo' do
  cwd node[:piwigo][:wwwdir]
  command "unzip #{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}.zip -d piwigo-#{node[:piwigo][:version]}"
  not_if { File.exists?("#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}") }
end

#template "#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/piwigo/local/config/database.inc.php" do
#  source "piwigo-database.inc.php.erb"
#  mode "0660"
#  owner 'www-data'
#  group 'www-data'
#  backup false
#  sensitive true
#end

execute "install piwigo database schema into mysql" do
  command "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf -u root #{node[:piwigo][:dbname]} < #{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/piwigo/install/piwigo_structure-mysql.sql"
  not_if "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf -u root -r -B -D #{node[:piwigo][:dbname]} -e 'show tables' | grep piwigo_config"
end

# activate_comments is set to true by config.sql
execute "install piwigo database local configs into mysql" do
  command "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf -u root #{node[:piwigo][:dbname]} < #{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/piwigo/install/config.sql"
  not_if "/usr/bin/mysql --defaults-extra-file=/root/.mysql-default.my.cnf -u root -r -B -D #{node[:piwigo][:dbname]} -e \"select value from piwigo_config where param = 'activate_comments';\" | grep true"
end

# after chef-client is run we don't need .my.cnf files
file "/root/.mysql-default.my.cnf" do
  action :delete
  backup false
  sensitive true
end

#link '/var/run/mysqld/mysqld.sock' do
#  to '/run/mysql-default/mysqld.sock'
#  not_if { ::File.symlink?'/var/run/mysqld/mysqld.sock' }
#end

#connection_info = {:host => node[:piwigo][:dbhost], :username => 'root', :password => node[:piwigo][:dbrootpass]}

# create database
#mysql_database node[:piwigo][:dbname] do
#  connection connection_info
#  action :create
#end

# grant all privilages on the database
#mysql_database_user node[:piwigo][:dbuser] do
#  connection connection_info
#  database_name node[:piwigo][:dbname]
#  password node[:piwigo][:dbuserpass]
#  action :grant
#end

# Auto Generated Passwords stored in Node Data
#::Chef::Node.send(:include, Opscode::OpenSSL::Password)
#set_unless[:piwigo][:dbpass] = secure_password
#set_unless[:piwigo][:adminpass] = secure_password

# create database, user, grants, installs php and uses it to install the db 
# schema, then set admin password
#include_recipe "piwigo::database-mysql"

# install the apache2 webserver, php, ssl certificates, and related configs
#if node[:piwigo][:webserver_apache2]
#  include_recipe "piwigo::webserver-apache2"
#end

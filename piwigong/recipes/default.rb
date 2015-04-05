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
  mode "0755"
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

%w[imagemagick mediainfo unzip libapache2-mod-php5].each do |packagedep|
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

#include_recipe "database"

connection_info = {:host => node[:piwigo][:dbhost], :username => 'root', :password => node[:piwigo][:dbrootpass]}

# create database
mysql_database node[:piwigo][:dbname] do
  connection connection_info
  action :create
end

# grant all privilages on the database
mysql_database_user node[:piwigo][:dbuser] do
  connection connection_info
  database_name node[:piwigo][:dbname]
  password node[:piwigo][:dbuserpass]
  action :grant
end

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

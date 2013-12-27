#
# Cookbook Name:: teampass
# Recipe:: default

# install teampass
include_recipe "teampass::corefiles"

# create database, user, and grants, but its the interactive web installer
# that installs the database schema
if node[:teampass][:database_mysql]
  include_recipe "teampass::database-mysql"
end

# install the apache2 webserver, php, ssl certificates, and web related configs
if node[:teampass][:webserver_apache2]
  include_recipe "teampass::webserver-apache2"
end

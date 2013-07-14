#
# Cookbook Name:: gallery
# Recipe:: default

# openssl is used to generate random passwords
include_recipe "openssl"

# install the gallery and optionally gallery-contrib files
include_recipe "gallery::corefiles"

# create database, user, grants, installs php and uses it to install the db 
# schema, then set admin password
# Postgresql is not yet supported by the Gallery team
include_recipe "gallery::database-mysql"

# install contrib modules
if node[:gallery][:contribmodules]
  include_recipe "gallery::contrib-modules"
end

# install contrib themes
if node[:gallery][:contribthemes]
  include_recipe "gallery::contrib-themes"
end

# install the apache2 webserver, php, ssl certificates, and related configs
if node[:gallery][:webserver_apache2]
  include_recipe "gallery::webserver-apache2"
end

#
# Cookbook Name:: gallery
# Recipe:: webserver-apache2

include_recipe "apache2"
include_recipe "apache2::mod_php5"

if node[:gallery][:apachessl]
  include_recipe "apache2::mod_ssl"
  include_recipe "apache2::mod_rewrite"
end

case node[:gallery][:sslcertmode]
when "default"
  include_recipe "certificate"
when "wildcard"
  include_recipe "certificate::wildcard"
when "manage_by_attributes"
  include_recipe "certificate::manage_by_attributes"
when "none"
  Chef::Log.warn("Skipping setup of ssl certificates using the 'certificate' cookbook.  You are on your own to setup ssl certificates.")
end

template "/etc/apache2/sites-available/gallery-apache.conf" do
  source "gallery-apache.conf.erb"
  mode "0644"
  notifies :reload, "service[apache2]"
end

template "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/php.ini" do
  source "gallery-php.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]"
end

template "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/.htaccess" do
  source "gallery-htaccess.erb"
  mode "0644"
end

apache_site "000-default" do
  enable false
end

apache_site "gallery-apache.conf" do
   enable true
end

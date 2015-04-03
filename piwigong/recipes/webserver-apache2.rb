#
# Cookbook Name:: piwigo
# Recipe:: webserver-apache2

include_recipe "apache2"
include_recipe "apache2::mod_php5"

if node[:piwigo][:apachessl]
  include_recipe "apache2::mod_ssl"
  include_recipe "apache2::mod_rewrite"
end

if node[:piwigo][:usechefvault]
  include_recipe "chef-vault"
  vault = chef_vault_item("vault", "#{node[:piwigo][:vaultitem]}")['server']

  file "#{node[:piwigo][:sslcertfile]}" do
    content vault['cert']
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
    action :create
    notifies :reload, "service[apache2]"
  end

  file "#{node[:piwigo][:sslkeyfile]}" do
    content vault['key']
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
    action :create
    notifies :reload, "service[apache2]"
  end

  file "#{node[:piwigo][:sslchainfile]}" do
    content vault['cacert']
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
    action :create
    notifies :reload, "service[apache2]"
  end
end

template "/etc/apache2/sites-available/piwigo-apache.conf" do
  source "piwigo-apache.conf.erb"
  mode "0644"
  notifies :reload, "service[apache2]"
end

template "#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/.htaccess" do
  source "piwigo-htaccess.erb"
  mode "0644"
end

apache_site "piwigo-apache" do
   enable true
end

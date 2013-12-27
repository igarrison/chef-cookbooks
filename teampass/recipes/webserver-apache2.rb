#
# Cookbook Name:: teampass
# Recipe:: webserver-apache2

# Satisfy our dependencies on other cookbooks
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "php"

if node[:teampass][:apachessl]
  include_recipe "apache2::mod_ssl"
  include_recipe "apache2::mod_rewrite"
end

if node[:teampass][:usechefvault]
  include_recipe "chef-vault"
  vault = chef_vault_item("vault", "#{node[:teampass][:vaultitem]}")['server']

  file "#{node[:teampass][:sslcertfile]}" do
    content vault['cert']
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
    action :create
    notifies :reload, "service[apache2]"
  end

  file "#{node[:teampass][:sslkeyfile]}" do
    content vault['key']
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
    action :create
    notifies :reload, "service[apache2]"
  end

  file "#{node[:teampass][:sslchainfile]}" do
    content vault['cacert']
    owner node[:apache][:user]
    group node[:apache][:group]
    mode 0640
    action :create
    notifies :reload, "service[apache2]"
  end
end

template "/etc/apache2/sites-available/teampass-apache.conf" do
  source "teampass-apache.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :reload, "service[apache2]"
end

apache_site "teampass-apache.conf" do
   enable true
end

template "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/.htaccess" do
  source "teampass-htaccess.erb"
  mode "0644"
end

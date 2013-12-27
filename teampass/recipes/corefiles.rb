#
# Cookbook Name:: teampass
# Recipe:: corefiles

# Satisfy our dependencies on other cookbooks
include_recipe "git"

# Install any remaining package dependencies 
%w[php5-mcrypt php5-ldap].each do |packagename|
  package packagename
end

# Create the dir for the releases
directory "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

# Pull the web files from github. 
git "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/" do
  repository node[:teampass][:gitrepo]
  reference node[:teampass][:version]
  #reference "master"
  action :checkout
end

# includes, install, files, and upload dirs need to be writable by webserver user
ruby_block "set #{node[:apache][:user]}:#{node[:apache][:user]} ownership for specific teampass directories" do
  block do
    %w{ includes install files upload }.each do |writabledirs|
      FileUtils.chown_R(node[:apache][:user], node[:apache][:group], "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/#{writabledirs}");
    end
  end
  not_if { Etc.getpwuid(::File.stat("#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/upload").gid).name == node[:apache][:group] }
end

# this secrets directory needs to be writable by the web server as
# it outputs some config from the web based installation routines
directory "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/secrets" do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0750"
  action :create
end

# Set a symlink for the current working directory in webroot
link "#{node[:teampass][:dir]}/current" do
  to "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/"
end

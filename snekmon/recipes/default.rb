#
# Cookbook Name:: snekmon
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Satisfy our dependencies on other cookbooks
include_recipe "git"
include_recipe 'runit::default'

#https://github.com/padelt/temper-python
#https://github.com/edorfaus/TEMPered

# Pull the web files from github. 
git node['snekmon']['temper_path'] do
  repository node['snekmon']['temper_gitrepo']
  reference "master"
  action :checkout
end

git node['snekmon']['tempered_path'] do
  repository node['snekmon']['tempered_gitrepo']
  reference "master"
  action :checkout
end

git node['snekmon']['hidapi_path'] do
  repository node['snekmon']['hidapi_gitrepo']
  reference "master"
  action :checkout
end

packages = value_for_platform_family("debian" => ["python-usb", "python-setuptools", "libudev-dev", "libusb-1.0-0-dev", "libfox-1.6-dev", "autotools-dev", "autoconf", "automake", "libtool", "cmake"])

packages.each do |pkg|
  package pkg
end

bash "run temper-python install" do
  cwd node['snekmon']['temper_path']
  code <<-EOF
  python setup.py install
  EOF
  not_if { ::File.exists?'/usr/local/bin/temper-poll' }
end

bash "run HIDAPI install" do
  cwd node['snekmon']['hidapi_path']
  code <<-EOF
  ./bootstrap
  ./configure
  make
  make install
  EOF
  not_if { ::File.exists?'/usr/local/lib/libhidapi-hidraw.so' }
end

bash "run TEMPered install" do
  cwd node['snekmon']['tempered_path']
  code <<-EOF
  cmake .
  make
  make install
  if [ -d /usr/local/lib/arm-linux-gnueabihf ] then
    find /usr/local/lib/arm-linux-gnueabihf/ ! -type d -exec ln -s {} /usr/local/lib \;
  fi
  ldconfig
  EOF
  not_if { ::File.exists?'/usr/local/bin/tempered' }
end

if Chef::Config[:solo]
  if node['snekmon']['graphite_address']
    graphite_server = node['snekmon']['graphite_address']
  else
    Chef::Application.fatal!("Chef Solo does not support search. You must set node['snekmon']['graphite_address']!")
  end
else
  graphite_server = search(:node, "roles:#{node['snekmon']['graphite_searchrole']} AND chef_environment:#{node.chef_environment} AND NOT tags:no-monitor").first['ipaddress']
end

if graphite_server.nil?
  Chef::Application.fatal!('The snekmon::default recipe was unable to determine the remote graphite server. Checked both the graphite_address and search!')
end

runit_service 'snekmon'

service "snekmon" do
  supports :status => true, :restart => true
  action :nothing
end

template "/usr/local/bin/snekmon.py" do
  source 'snekmon.py.erb'
  owner     'root'
  group     'root'
  mode      '0755'
  notifies :restart, 'service[snekmon]'
  variables(
    :graphite_ip => graphite_server,
    :graphite_port => node['snekmon']['graphite_port'],
    :poll_interval => node['snekmon']['poll_interval']
  )
end

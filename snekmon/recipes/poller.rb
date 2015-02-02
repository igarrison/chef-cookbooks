#
# Cookbook Name:: snekmon
# Recipe:: poller
#
# Author: Ian Garrison <garrison@technoendo.net>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "git"
include_recipe 'runit::default'

git "#{Chef::Config[:file_cache_path]}/temper" do
  repository 'https://github.com/padelt/temper-python.git'
  reference "master"
  action :checkout
end

git "#{Chef::Config[:file_cache_path]}/TEMPered" do
  repository 'https://github.com/edorfaus/TEMPered.git'
  reference "master"
  action :checkout
end

git "#{Chef::Config[:file_cache_path]}/hidapi" do
  repository 'https://github.com/signal11/hidapi.git'
  reference "master"
  action :checkout
end

packages = value_for_platform_family("debian" => ["python-usb", "python-setuptools", "libudev-dev", "libusb-1.0-0-dev", "libfox-1.6-dev", "autotools-dev", "autoconf", "automake", "libtool", "cmake"])

packages.each do |pkg|
  package pkg
end

bash "run temper-python install" do
  cwd "#{Chef::Config[:file_cache_path]}/temper"
  code <<-EOF
  python setup.py install
  EOF
  not_if { ::File.exists?'/usr/local/bin/temper-poll' }
end

bash "run HIDAPI install" do
  cwd "#{Chef::Config[:file_cache_path]}/hidapi"
  code <<-EOF
  ./bootstrap
  ./configure
  make
  make install
  EOF
  not_if { ::File.exists?'/usr/local/lib/libhidapi-hidraw.so' }
end

bash "run TEMPered install" do
  cwd "#{Chef::Config[:file_cache_path]}/TEMPered"
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

if node['snekmon']['graphite_address']
  graphite_server = node['snekmon']['graphite_address']
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

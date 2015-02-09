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
include_recipe "snekmon::common"
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

packages = value_for_platform_family("debian" => ["python-usb", "libudev-dev", "libusb-1.0-0-dev", "libfox-1.6-dev", "autotools-dev", "autoconf", "automake", "libtool", "cmake"])

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
  code <<-'EOF'
  cmake .
  make
  make install
  find /usr/local/lib -name "libtempered*" -exec ln -s {} /usr/local/lib \;
  ldconfig
  EOF
  not_if { ::File.exists?'/usr/local/bin/tempered' }
end

template "/usr/local/bin/snekmon-poller.py" do
  source 'snekmon-poller.py.erb'
  owner     'root'
  group     'root'
  mode      '0755'
  variables(
    :graphite_ip => graphite_server,
    :graphite_port => node['snekmon']['graphite_port'],
    :poll_interval => node['snekmon']['poll_interval']
  )
end

directory '/var/log/snekmon' do
  owner "root"
  group "root"
  mode "0755"
end

runit_service 'snekmon' do
  default_logger true
end

service "snekmon" do
  supports :status => true, :restart => true
  action :start
end

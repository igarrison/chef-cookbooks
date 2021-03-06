#
# Cookbook Name:: snekmon
# Recipe:: alerter
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

git "#{Chef::Config[:file_cache_path]}/prowlpy" do
  repository 'https://github.com/jacobb/prowlpy.git'
  reference "master"
  action :checkout
end

bash "run prowlpy install" do
  cwd "#{Chef::Config[:file_cache_path]}/prowlpy"
  code <<-EOF
  python setup.py install
  touch /var/run/prowlpy.ftr
  EOF
  not_if { ::File.exists?'/var/run/prowlpy.ftr' }
end

template "/usr/local/bin/snekmon-alerter.py" do
  source 'snekmon-alerter.py.erb'
  owner     'root'
  group     'root'
  mode      '0755'
  variables(
    :hotside_toohot => node['snekmon']['hotside_toohot'],
    :hotside_toocold => node['snekmon']['hotside_toocold'],
    :coolside_toocold => node['snekmon']['coolside_toocold'],
    :center_lowhumid => node['snekmon']['center_lowhumid'],
    :prowlapi_key => node['snekmon']['prowlapi_key'],
    :graphite_ip => graphite_server,
    :graphite_userurl => node['snekmon']['graphite_userurl']
  )
end

cron_d 'snekmon-alerter' do
  minute  '00,30'
  command '/usr/local/bin/snekmon-alerter.py'
  user    'root'
end

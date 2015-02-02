#
# Cookbook Name:: snekmon
# Recipe:: alerting
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Satisfy our dependencies on other cookbooks
include_recipe "git"

#https://github.com/jacobb/prowlpy

git node['snekmon']['prowlpy_path'] do
  repository node['snekmon']['prowlpy_gitrepo']
  reference "master"
  action :checkout
end

#packages = value_for_platform_family("debian" => ["autotools-dev", "autoconf", "automake", "libtool", "cmake"])

#packages.each do |pkg|
#  package pkg
#end

bash "run prowlpy install" do
  cwd node['snekmon']['prowlpy_path']
  code <<-EOF
  python setup.py install
  touch /var/run/prowlpy.ftr
  EOF
  not_if { ::File.exists?'/var/run/prowlpy.ftr' }
end

#if Chef::Config[:solo]
if node['snekmon']['graphite_address']
  graphite_server = node['snekmon']['graphite_address']
else
  #Chef::Application.fatal!("Chef Solo does not support search. You must set node['snekmon']['graphite_address']!")
  #end
#else
  graphite_server = search(:node, "roles:#{node['snekmon']['graphite_searchrole']} AND chef_environment:#{node.chef_environment} AND NOT tags:no-monitor").first['ipaddress']
end

if graphite_server.nil?
  Chef::Application.fatal!('The snekmon::default recipe was unable to determine the remote graphite server. Checked both the graphite_address and search!')
end

template "/usr/local/bin/snekmon-alerts.py" do
  source 'snekmon-alerts.py.erb'
  owner     'root'
  group     'root'
  mode      '0755'
  variables(
    :email_recipient => node['snekmon']['email_recipient'],
    :email_sender => node['snekmon']['email_sender'],
    :mailserver_host => node['snekmon']['mailserver_host'],
    :prowlapi_key => node['snekmon']['prowlapi_key'],
    :graphite_ip => graphite_server,
    :graphite_url => node['snekmon']['graphite_url']
  )
end

cron_d 'snekmon-alert' do
  minute  '00,30'
  command '/usr/local/bin/snekmon-alerts.py'
  user    'root'
end


#
# Cookbook Name:: snekmon
# Libraries:: helpers
#
# Author: Ian Garrison <garrison@technoendo.net>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def graphite_server
  if node['snekmon']['graphite_address']
    graphite_server = node['snekmon']['graphite_address']
  else
    graphite_server = search(:node, "roles:#{node['snekmon']['graphite_searchrole']} AND chef_environment:#{node.chef_environment} AND NOT tags:no-monitor").first['ipaddress']
  end

  if graphite_server.nil?
    Chef::Application.fatal!('The snekmon cookbook was unable to determine the remote graphite server. Checked both the graphite_address and search!')
  end

  return graphite_server
end

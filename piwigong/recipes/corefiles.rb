#
# Cookbook Name:: piwigo
# Recipe:: corefiles

# Install packages piwigo will depend on
%w[imagemagick mediainfo].each do |packagedep|
  package packagedep
end

directory node[:piwigo][:wwwdir] do
  mode "0755"
  action :create
  recursive true
end

include_recipe "ark"

ark "piwigo-#{node[:piwigo][:version]}" do
  url node[:piwigo][:zipurl]
  #creates "piwigo-#{node[:piwigo][:version]}.zip"
  extension "zip"
  path node[:piwigo][:wwwdir]
  action :put
end

#if File.directory?("#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/var")
#
#  # The piwigo install routines will set the var files to mode 777 which would
#  # any user on the system to modify them.  I'd prefer to change ownership to
#  # the user running the webserver and only allow modification by that user
#  ruby_block "set mode 640 for piwigo var files and 755 for piwigo var dirs" do
#    block do
#      require 'find'
#      Find.find( "#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/var" ) do |path|
#        if File.file? path
#          File.chmod(0640, path)
#        elsif File.directory? path
#          File.chmod(0755, path)
#        end
#      end
#    end
#    not_if { ::File.stat("#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/var").mode == 16877 }
#  end
#
#  ruby_block "set #{node[:apache][:user]}:#{node[:apache][:user]} ownership for piwigo var files" do
#    block do
#      FileUtils.chown_R(node[:apache][:user], node[:apache][:user], "#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/var")
#    end
#    not_if { Etc.getpwuid(::File.stat("#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}/var").gid).name == node[:apache][:user] }
#  end
#
#end

link "#{node[:piwigo][:wwwdir]}/current" do
  to "#{node[:piwigo][:wwwdir]}/piwigo-#{node[:piwigo][:version]}"
  not_if { ::File.symlink?"#{node[:piwigo][:wwwdir]}/current" }
end

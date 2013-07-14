#
# Cookbook Name:: gallery
# Recipe:: corefiles

# Install packages gallery will depend on
%w[graphicsmagick imagemagick ffmpeg].each do |packagedep|
  package packagedep
end

directory node[:gallery][:wwwdir] do
  mode "0755"
  action :create
  recursive true
end

if node[:gallery][:gitinstall]

  include_recipe "git"

  git "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/" do
    repository node[:gallery][:gitrepo]
    reference "3.0.x"
    action :sync
  end

  git "#{node[:gallery][:wwwdir]}/gallery-contrib/" do
    repository node[:gallery][:gitcontribrepo]
    reference "master"
    action :sync
    only_if { node[:gallery][:contribmodules] == true || node[:gallery][:contribthemes] == true }
  end

else

  include_recipe "ark"

  ark "gallery-#{node[:gallery][:version]}" do
    url node[:gallery][:zipurl]
    path node[:gallery][:wwwdir]
    action :put
  end

  ark 'gallery-contrib' do
    url node[:gallery][:contribzipurl]
    path node[:gallery][:wwwdir]
    action :put
    strip_leading_dir
    only_if { node[:gallery][:contribmodules] == true || node[:gallery][:contribthemes] == true }
  end
end

if File.directory?("#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/var")

  # The gallery install routines will set the var files to mode 777 which would
  # any user on the system to modify them.  I'd prefer to change ownership to
  # the user running the webserver and only allow modification by that user
  ruby_block "set mode 640 for gallery var files and 755 for gallery var dirs" do
    block do
      require 'find'
      Find.find( "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/var" ) do |path|
        if File.file? path
          File.chmod(0640, path)
        elsif File.directory? path
          File.chmod(0755, path)
        end
      end
    end
    not_if { ::File.stat("#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/var").mode == 16877 }
  end

  ruby_block "set #{node[:apache][:user]}:#{node[:apache][:user]} ownership for gallery var files" do
    block do
      FileUtils.chown_R(node[:apache][:user], node[:apache][:user], "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/var")
    end
    not_if { Etc.getpwuid(::File.stat("#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/var").gid).name == node[:apache][:user] }
  end

end

link "#{node[:gallery][:wwwdir]}/current" do
  to "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}"
  not_if { ::File.symlink?"#{node[:gallery][:wwwdir]}/current" }
end

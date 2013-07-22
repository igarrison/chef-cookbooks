#
# Cookbook Name:: gallery
# Recipe:: contrib-modules

node[:gallery][:module].keys.each do |mod|

 
  if node[:gallery][:module][mod.to_s]
    gallery_module mod.to_s
  end
 
  case mod
  when "image_optimizer"
 
    %w[gifsicle optipng libjpeg-progs].each do |imgpackage|
      package imgpackage
    end
 
  when "ldap"
    include_recipe "apache2::mod_ldap"
    include_recipe "php::module_ldap"
 
    allgroups = node[:gallery][:ldapmodule][:allgroups].map{|s| "\"#{s}\""}.join(', ')
    adminusers = node[:gallery][:ldapmodule][:adminusers].map{|s| "\"#{s}\""}.join(', ')
 
    template "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/modules/ldap/config/identity.php" do
      source "ldap-identity.php.erb"
      mode "0640"
      group node[:apache][:group]
      variables(
        :allgroups => allgroups,
        :adminusers => adminusers
      )
    end

  when "aws_s3"
    include_recipe "php::module_curl"

  when "rawphoto"
    package "dcraw" do
      action :install
    end

  when "pdf"
    package "ghostscript" do
      action :install
    end
  end
end

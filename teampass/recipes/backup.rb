#
# Cookbook Name:: teampass
# Recipe:: backup

include_recipe "opscode-backup::client"

rsyncd_server = search(:node, "role:backup-server AND chef_environment:#{node.chef_environment}").first
unless rsyncd_server
  Chef::Log.info "No rsync servers found, skipping opscode-backups::client"
  return
end

template "/usr/local/sbin/teampass_backup-pre.sh" do
  source "teampass_backup-pre.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

directory node['teampass']['backup_dir'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

directory "#{node['teampass']['backup_dir']}/current"
directory "#{node['teampass']['backup_dir']}/archive"

opscode_backup "teampass" do
  server rsyncd_server['fqdn']
  directory "#{node['teampass']['backup_dir']}/current"
  cron_schedule node['teampass']['backup_schedule']
  target node.roles.grep(/teampass/).first
  password_file node[:opscode_backup][:rsyncd][:secrets_file]
  pre_cmd "/usr/local/sbin/teampass_backup-pre.sh"
  post_cmd "find #{node['teampass']['backup_dir']}/archive -type f -cmin +180 -exec rm -rf {} \;"
end

#
# Cookbook Name:: teampass
# Recipe:: database-mysql

# Satisfy our dependencies on other cookbooks
include_recipe "php::module_mysql"
include_recipe "mysql::server"
include_recipe "mysql::ruby"
include_recipe "database"

connection_info = {:host => node[:teampass][:dbhost], :username => 'root', :password => node[:mysql][:server_root_password]}

# create database
mysql_database node[:teampass][:dbname] do
  connection connection_info
  action :create
end

# grant all privilages on the database
mysql_database_user node[:teampass][:dbuser] do
  connection connection_info
  database_name node[:teampass][:dbname]
  password node[:teampass][:dbpass]
  action :grant
end

# in 2.1.19 the password hashing mechanism used by teampass was found to only be
# compatible with the Mysql 4.0 compatible password hashing (old_password=ON)
#SET PASSWORD FOR ‘user’@'server_ip’ = OLD_PASSWORD(‘my_password’)
mysql_database "use Mysql 4.0 compatible password hashing" do
  connection connection_info
  database_name "mysql"
  sql "SET PASSWORD FOR #{node[:teampass][:dbuser]}@'#{node[:teampass][:dbhost]}' = OLD_PASSWORD('#{node[:teampass][:dbpass]}')"
  action :query
  not_if "test -f #{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/database-mysql-#{node[:teampass][:version]}.txt"
end

# in the name of idempotency and security lets only run the mysql 4.0 
# compatible password hashing routine above once per version change instead of
# every time
file "#{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/database-mysql-#{node[:teampass][:version]}.txt" do
  content "# this file created by the teampass cookbook after setting mysql 4.0 compatible password hashing.  Instead of running every chef-client run we'll limit this to one run per install of a version of teampass.  It is safe to delete this file but it will be recreated next chef-client run."
  action :create_if_missing
  not_if "test -f #{node[:teampass][:dir]}/releases/#{node[:teampass][:version]}/database-mysql-#{node[:teampass][:version]}.txt"
end

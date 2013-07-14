#
# Cookbook Name:: gallery
# Recipe:: contrib-themes

node[:gallery][:themeslist].each do |theme|
  gallery_theme theme do
    action :create
  end
end

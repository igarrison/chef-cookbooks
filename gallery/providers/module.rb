use_inline_resources if defined?(use_inline_resources)

action :create do

  unless ::File.directory?("#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/modules/#{new_resource.name}")

    ruby_block "Copy #{new_resource.name} module from gallery-contrib to gallery modules directory" do
      block do
        ::FileUtils.cp_r("#{node[:gallery][:wwwdir]}/gallery-contrib/3.0/modules/#{new_resource.name}","#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/modules/#{new_resource.name}")
      end
    end
  end
end

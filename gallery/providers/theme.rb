action :create do

  unless ::File.directory?("#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/themes/#{new_resource.name}")

    ruby_block "Copy #{new_resource.name} theme from gallery-contrib to gallery themes directory" do
      block do
        ::FileUtils.cp_r("#{node[:gallery][:wwwdir]}/gallery-contrib/3.0/themes/#{new_resource.name}","#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/themes/#{new_resource.name}")
      end
    end

    new_resource.updated_by_last_action(true)
  end
end

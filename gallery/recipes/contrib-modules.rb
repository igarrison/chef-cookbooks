#
# Cookbook Name:: gallery
# Recipe:: contrib-modules

if node[:gallery][:module][:about_this_album]
  gallery_module "about_this_album"
end

if node[:gallery][:module][:about_this_photo]
  gallery_module "about_this_photo"
end

if node[:gallery][:module][:about]
  gallery_module "about"
end

if node[:gallery][:module][:addsense]
  gallery_module "addsense"
end

if node[:gallery][:module][:addthis]
  gallery_module "addthis"
end

if node[:gallery][:module][:albumpassword]
  gallery_module "albumpassword"
end

if node[:gallery][:module][:albumtree]
  gallery_module "albumpassword"
end

if node[:gallery][:module][:allcomments]
  gallery_module "allcomments"
end

if node[:gallery][:module][:all_tags]
  gallery_module "all_tags"
end

if node[:gallery][:module][:atom]
  gallery_module "atom"
end

if node[:gallery][:module][:author]
  gallery_module "author"
end

if node[:gallery][:module][:auto_date]
  gallery_module "auto_date"
end

if node[:gallery][:module][:autorotate]
  gallery_module "autorotate"
end

if node[:gallery][:module][:aws_s3]
  include_recipe "php::module_curl"

  gallery_module "aws_s3"
end

if node[:gallery][:module][:basket]
  gallery_module "basket"
end

if node[:gallery][:module][:basket_plus]
  gallery_module "basket_plus"
end

if node[:gallery][:module][:user_albums]
  gallery_module "user_albums"
end

if node[:gallery][:module][:user_chroot]
  gallery_module "user_chroot"
end

if node[:gallery][:module][:user_rest]
  gallery_module "user_rest"
end

if node[:gallery][:module][:win_platform]
  gallery_module "videodimensions"
end

if node[:gallery][:module][:wordpress_auth]
  gallery_module "wordpress_auth"
end

if node[:gallery][:module][:webdav]
  gallery_module "webdav"
end

if node[:gallery][:module][:batchtag]
  gallery_module "batchtag"
end

if node[:gallery][:module][:calendarview]
  gallery_module "calendarview"
end

if node[:gallery][:module][:captionator]
  gallery_module "captionator"
end

if node[:gallery][:module][:user_homes]
  gallery_module "user_homes"
end

if node[:gallery][:module][:contactowner]
  gallery_module "contactowner"
end

if node[:gallery][:module][:content_warning]
  gallery_module "content_warning"
end

if node[:gallery][:module][:custom_menus]
  gallery_module "custom_menus"
end

if node[:gallery][:module][:database_info]
  gallery_module "database_info"
end

if node[:gallery][:module][:date_tag]
  gallery_module "date_tag"
end

if node[:gallery][:module][:default_sort]
  gallery_module "default_sort"
end

if node[:gallery][:module][:developer]
  gallery_module "developer"
end

if node[:gallery][:module][:displaytags]
  gallery_module "displaytags"
end

if node[:gallery][:module][:dynamic]
  gallery_module "dynamic"
end

if node[:gallery][:module][:ecard]
  gallery_module "ecard"
end

if node[:gallery][:module][:editcaptured]
  gallery_module "editcaptured"
end

if node[:gallery][:module][:editcreation]
  gallery_module "editcreation"
end

if node[:gallery][:module][:embedlinks]
  gallery_module "embedlinks"
end

if node[:gallery][:module][:embed_videos]
  gallery_module "embedlinks"
end

if node[:gallery][:module][:emboss]
  gallery_module "emboss"
end

if node[:gallery][:module][:event_watcher]
  gallery_module "event_watcher"
end

if node[:gallery][:module][:export_facebook]
  gallery_module "export_facebook"
end

if node[:gallery][:module][:facebook_opengraph]
  gallery_module "facebook_opengraph"
end

if node[:gallery][:module][:favourites]
  gallery_module "favourites"
end

if node[:gallery][:module][:fittoscreen]
  gallery_module "fittoscreen"
end

if node[:gallery][:module][:fotomotorw]
  gallery_module "fotomotorw"
end

if node[:gallery][:module][:g1_import]
  gallery_module "g1_import"
end

if node[:gallery][:module][:google_analytics]
  gallery_module "google_analytics"
end

if node[:gallery][:module][:gwtorganize]
  gallery_module "gwtorganize"
end

if node[:gallery][:module][:hide]
  gallery_module "hide"
end

if node[:gallery][:module][:highroller]
  gallery_module "highroller"
end

if node[:gallery][:module][:html5_uploader]
  gallery_module "html5_uploader"
end

if node[:gallery][:module][:html_uploader]
  gallery_module "html_uploader"
end

if node[:gallery][:module][:iptc]
  gallery_module "iptc"
end

if node[:gallery][:module][:itemchecksum]
  gallery_module "itemchecksum"
end

if node[:gallery][:module][:metadescription]
  gallery_module "metadescription"
end

if node[:gallery][:module][:minislideshow]
  gallery_module "minislideshow"
end

if node[:gallery][:module][:moduleorder]
  gallery_module "moduleorder"
end

if node[:gallery][:module][:no_home_link]
  gallery_module "no_home_link"
end

if node[:gallery][:module][:pages]
  gallery_module "pages"
end

if node[:gallery][:module][:pam]
  gallery_module "pam"
end

if node[:gallery][:module][:photo_annotation]
  gallery_module "photo_annotation"
end

if node[:gallery][:module][:phpmailer]
  gallery_module "phpmailer"
end

if node[:gallery][:module][:picasa_faces]
  gallery_module "picasa_faces"
end

if node[:gallery][:module][:polar_rose]
  gallery_module "polar_rose"
end

if node[:gallery][:module][:proofsheet]
  gallery_module "proofsheet"
end

if node[:gallery][:module][:quotas]
  gallery_module "quotas"
end

if node[:gallery][:module][:rectangle_thumbs]
  gallery_module "rectangle_thumbs"
end

if node[:gallery][:module][:remote]
  gallery_module "remote"
end

if node[:gallery][:module][:rescue]
  gallery_module "rescue"
end

if node[:gallery][:module][:scheduler]
  gallery_module "scheduler"
end

if node[:gallery][:module][:sharephoto]
  gallery_module "sharephoto"
end

if node[:gallery][:module][:short_search_fix]
  gallery_module "short_search_fix"
end

if node[:gallery][:module][:social_share]
  gallery_module "social_share"
end

if node[:gallery][:module][:square_thumbs]
  gallery_module "square_thumbs"
end

if node[:gallery][:module][:sso]
  gallery_module "sso"
end

if node[:gallery][:module][:star]
  gallery_module "star"
end

if node[:gallery][:module][:strip_exif]
  gallery_module "strip_exif"
end

if node[:gallery][:module][:tag_albums]
  gallery_module "tag_albums"
end

if node[:gallery][:module][:tag_cloud]
  gallery_module "tag_cloud"
end

if node[:gallery][:module][:tag_cloud_html5]
  gallery_module "tag_cloud_html5"
end

if node[:gallery][:module][:tag_cloud_page]
  gallery_module "tag_cloud_page"
end

if node[:gallery][:module][:tagfaces]
  gallery_module "tagfaces"
end

if node[:gallery][:module][:tag_it]
  gallery_module "tag_it"
end

if node[:gallery][:module][:tagsinalbum]
  gallery_module "tagsinalbum"
end

if node[:gallery][:module][:tagsmap]
  gallery_module "tagsmap"
end

if node[:gallery][:module][:themeroller]
  # the theme directory needs to be writable by the web server
  #ruby_block "set #{node[:apache][:user]}:#{node[:apache][:user]} ownership for the gallery theme directory (themeroller)" do
  #  block do
  #    FileUtils.chown(node[:apache][:user], node[:apache][:user], "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/themes")
  #  end
  #  not_if { Etc.getpwuid(::File.stat("#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/themes").gid).name == node[:apache][:user] }
  #end

  gallery_module "themeroller"
end

if node[:gallery][:module][:transcode]
  gallery_module "transcode"
end

if node[:gallery][:module][:transliterate]
  gallery_module "transliterate"
end

if node[:gallery][:module][:unrest]
  gallery_module "unrest"
end

if node[:gallery][:module][:user_info]
  gallery_module "user_info"
end

if node[:gallery][:module][:rawphoto]

  package "dcraw" do
    action :install
  end

  gallery_module "rawphoto"
end

if node[:gallery][:module][:register]
  gallery_module "register"
end

if node[:gallery][:module][:session_explorer]
  gallery_module "session_explorer"
end

if node[:gallery][:module][:rwinfo]
  gallery_module "rwinfo"
end

if node[:gallery][:module][:purifier]
  gallery_module "purifier"
end

if node[:gallery][:module][:pdf]

  package "ghostscript" do
    action :install
  end

  gallery_module "pdf"
end

if node[:gallery][:module][:panorama]
  gallery_module "panorama"
end

if node[:gallery][:module][:nobots]
  gallery_module "nobots"
end

if node[:gallery][:module][:navcarousel]
  gallery_module "navcarousel"
end

if node[:gallery][:module][:movie_overlay]
  gallery_module "movie_overlay"
end

if node[:gallery][:module][:movie_tools]
  gallery_module "movie_tools"
end

if node[:gallery][:module][:moduleupdates]
  gallery_module "moduleupdates"
end

if node[:gallery][:module][:latestupdates]
  gallery_module "latestupdates"
end

if node[:gallery][:module][:image_optimizer]

  %w[gifsicle optipng libjpeg-progs].each do |imgpackage|
     package imgpackage
  end

  gallery_module "image_optimizer"
end

if node[:gallery][:module][:gmaps]
  gallery_module "gmaps"
end

if node[:gallery][:module][:downloadalbum]
  gallery_module "downloadalbum"
end

if node[:gallery][:module][:downloadfullsize]
  gallery_module "downloadfullsize"
end

if node[:gallery][:module][:carousel]
  gallery_module "carousel"
end

if node[:gallery][:module][:keeporiginal]
  gallery_module "keeporiginal"
end

if node[:gallery][:module][:exif_gps]
  gallery_module "exif_gps"
end

if node[:gallery][:module][:arrow_nav]
  gallery_module "arrow_nav"
end

if node[:gallery][:module][:ldap]

  include_recipe "apache2::mod_ldap"
  include_recipe "php::module_ldap"

  allgroups = node[:gallery][:module][:ldapmod][:allgroups].map{|s| "\"#{s}\""}.join(', ')
  adminusers = node[:gallery][:module][:ldapmod][:adminusers].map{|s| "\"#{s}\""}.join(', ')

  gallery_module "ldap" do
    action :create
  end

  template "#{node[:gallery][:wwwdir]}/gallery-#{node[:gallery][:version]}/modules/ldap/config/identity.php" do
    source "ldap-identity.php.erb"
    mode "0640"
    group node[:apache][:group]
    variables(
      :allgroups => allgroups,
      :adminusers => adminusers
    )
  end

end

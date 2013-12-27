#!/usr/bin/env ruby

require 'rubygems'
require 'json'

def process_pem(filename)
  output = ""
  File.open(filename).each_line do |line|
    output << line
  end
  output
end

content = {
  :id => "selfsigned_wildcard_ssl_cert",
  :server => {
    :key => process_pem("server/key.pem"),
    :cert => process_pem("server/cert.pem"),
    :cacert => process_pem("certificates_ca/cacert.pem")
  }
}

File.open("selfsigned_wildcard_ssl_cert.json","w") do |data_bag_item|
  data_bag_item.puts JSON.pretty_generate(content)
end

puts "Data bag item created: selfsigned_wildcard_ssl_cert.json"

puts "now run 'knife user list', figure out which users to grant access to, look at your roles and see what scope of clients (servers managed by chef) you want able to access the credentials.  I ran the following to grant myself, admin, and all clients in the base role access to the cert: knife encrypt create vault selfsigned_wildcard_ssl_cert --json ./selfsigned_wildcard_ssl_cert.json --search 'roles:base' --admins admin,garrison --mode client"

Description
===========

Teampass is a collaborative password manager that runs on a LAMP stack.  It offers role based access control for more granular control of who has access to certain folders or password items.  It supports ldap/Active Directory and google multi factor authentication systems.

http://www.teampass.net/

Requirements
============

* Apache
* MySQL
* PHP version 5.3 or higher
* PHP extension “mcrypt” enabled

Optional

* For LDAP, PHP extension “LDAP” enabled
* chef-vault is used by this cookbook for ssl certificate management
* mod-ssl and mod-rewrite apache2 modules if SSL is used

Platform
--------

* Ubuntu 12.04+
* Debian 7.0+

Cookbooks
---------

Requires community site cookbooks: openssl, mysql, database, git, php, apache2, and chef-vault cookbooks.  See _Attributes_ and _Usage_ for more information.

Attributes
==========

Database Attributes
-------------------

* `node['teampass']['database_mysql']` - if true the database recipe will run on the same server which installs MySQL, creates a database for Teampass, and creates a user with grants allowing it to modify its own database.  if false we won't do any of this, you will have to manage databases and grants yourself
* `node['teampass']['dbname']` - MySQL Database name to use for this teampass installation (defaults to "teampassdb")
* `node['teampass']['dbuser']` - Username teampass will use when communicating with a local or remote MySQL server (defaults to "teampassadmin")
* `node['teampass']['dbpass']` - Teampass user's MySQL database password randomly generated by OpenSSL and stored in the node data (note: should move this to chef vault!)
* `node['teampass']['dbhost']` - Hostname teampass will use when communicating with a local or remote MySQL server (defaults to "localhost").  If a remote server is used you will be left to setup the database name and grants yourself.

Chef Vault Attributes
-------------------------
* `node['teampass']['usechefvault']` - Toggle whether to use chef-vault for SSL certificate management or not.  If "false" you will need to install certificates by your own means (default is "true").
* `node['teampass']['vaultitem']` - This is used to set the name of the encrypted data bag created and managed by chef-vault.  When using wildcard certs this might be `selfsigned_wildcard_ssl_cert`.


Web/Apache/SSL Attributes
-------------------------

* `node['teampass']['wwwname']` - Hostname users will use to reach this teampass installation (default is "teampass.example.com")
* `node['teampass']['email']` - Email address of the Teampass site administrator (defaults to "postmaster@example.com")
* `node['teampass']['webserver_apache2']` - Toggle whether to install and configure Apache2 for the Teampass install or to perform no webserver installation at all (default is "true" to install Apache2).  No webserver installed means it is being left to the user to install/configure some other webserver.
* `node['teampass']['sslcertdir']` - Directory containing SSL certificates, keys, and CA/Intermediary certificates (default "/etc/apache2/ssl")
* `node['teampass']['sslcertfile']` - The PEM formatted SSL certificate file used in HTTPS communications (default `/etc/apache2/ssl/selfsigned_wildcard.pem`)
* `node['teampass']['sslkeyfile']` - The SSL certificate private key file used in HTTPS communications (default `/etc/apache2/ssl/selfsigned_wildcard.key`)
* `node['teampass']['sslchainfile']` - The PEM formatted SSL certificate file used in HTTPS communications to complete the chain of trust between web browsers, web servers, and your chosen Certificate Authorities (default `/etc/apache2/ssl/selfsigned_wildcard_cacert.pem`)

Teampass Core Attributes
-------------------------------------------

* `node['teampass']['dir']` - The install directory which is also served via Apache2 (default "/var/www/teampass")
* `node['teampass']['version']` - The Teampass version to install (default "2.1.19")
* `node['teampass']['gitrepo']` - Git repository for Teampass install files (default "git://github.com/nilsteampassnet/TeamPass.git")

Usage
=====

First thing read the _SSL Certificates_ section below and get some vault items created with your preferred type of certificate.

See the 'examples/roles/teampass-server.json' file in this cookbook as a role example, copy to your roles directory, and modify as desired.  Apply this 'teampass-server' role to the `run_list` of a node you want to apply it to.

Run chef-client to execute the teampass cookbook.  If the cookbook is using chef-vault to manage certificate installation and it has errors make sure to check ithe _Chef Vault_ section below for more details.  For chef-client to converge cleanly you need to have chef-vault encrypted data bags installed in a "vault" data bag with the vaultitem attribute storing its name, and the chef client as seen from the chef server needs to have permission to decrypt the vault item.  Work through these issues until you can run chef-client without error.

At this point you have a working apache2 webserver and a mysql database and user with permissions to do things to that database but no schema or data is loaded into the database yet.  Go to `http://TEAMPASSURL/install/install.php` to begin the web based installation.

When you get to "Absolute path to SaltKey" use `/var/www/teampass/current/secrets` if you are installing to `/var/www/teampass`.  If the cookbook worked correctly this dir should exist and be writable by the webserver.  This phase of the installation will write the SaltKey php config into this secrets directory.

Once you are logged in as `admin`/`admin` create some folders, add a role, and adjust the general settings as needed.  Once the basic installation is done the files/settings on disk for the local installation and teampass mysql database will not be managed by this cookbook.

SSL Certificates
================

If you already have commercial certificates setup `override_attributes` in a role for the following attributes: `[:teampass][:vaultitem]`, and possibly `[:teampass][:sslcertfile]`, `[:teampass][:sslkeyfile]`, and `[:teampass][:sslchainfile]`.  With the vaultitem name you should read the Chef Vault section below and learn about importing your certs into a chef vault encrypted data bag and how to manage access to it.

If you do not already have certs the sensu team had a great shell script and openssl.cnf for generating a Certificate Authority and self-signed certificate that I adopted and extended with wildcard domains and Subject Alternate Names (SAN, multiple domains and subdomain support).  Generating ssl certificates for each server and/or service is tedious so instead use one that can be deployed everywhere that can be deployed quickly and without financial cost.  If its compromised or you want to change certificates periodically just update the vault item and have chef-client deploy the new certificates.

To generate a new CA and wildcard cert edit `examples/ssl/ssl_certs.sh` and `examples/ssl/certificates_ca/openssl.cnf` (especially around words like 'example' and 'Example'), and then run `ssl_certs.sh generate` to generate a CAcert/server certificate/key.  This will produce a `selfsigned_wildcard_ssl_cert.json` file with all three items which can consumed by chef-vault (see _Chef Vault_ section below), or encrypted/unencrypted data bags in your own wrapper cookbook.

If you do use `ssl_certs.sh` to generate certs be sure to copy the public CAcert file `examples/ssl/certificates_ca/cacert.pem` some place safe and maybe attach it to an internal wiki page.  It can be imported into web browsers like Firefox and Chrome as an "authority" and this completes the browser SSL chain of trust verification check so the browser bar turns green and doesn't display warnings to the user and requiring manual acceptance of an untrusted certificate.

Chef Vault
==========

https://github.com/Nordstrom/chef-vault

I think its the best chef pattern for secrets management right now.  You don't have to copy keyfiles to servers to be used with encrypted data bags and instead use the client keys of servers/people on the chef server.  You can control who can access the credentials and chef-vault knife commands + json files is a workable framework for automating password changes for me.

'gem install chef-vault' to install it.  Probably a good idea to read some chef vault documentation or web sites but I'll include a few quick tips below.

If you have your own commercial certs copy the `examples/vault/selfsigned_wildcard_ssl_cert.json` and use it as an example template for creating a .json file to be ingested with chef vault.  Once you have made a customized `wildcard_yourdomain_com_ssl_cert.json` import it with this command:

`knife encrypt create vault wildcard_yourdomain_com_ssl_cert --json ./wildcard_yourdomain_com_ssl_cert.json --search 'roles:base' --admins admin,youruser,user1,user2 --mode client`

If you are using the `selfsigned_wildcard_ssl_cert.json` run something like this:

`knife encrypt create vault selfsigned_wildcard_ssl_cert --json ./selfsigned_wildcard_ssl_cert.json --search 'roles:base' --admins admin,youruser,user1,user2 --mode client`

Use some other list of users or scope of servers as you see fit.  Note that you can always 'knife data bag list' and 'knife data bag show' commands around the vault you will notice for each vault item 2 data bags are created.  The one with `_keys` in the name always shows the list of users and servers with permissions to decrypt the chef vault data. 

To decrypt the vault stored on the server:

`knife decrypt vault selfsigned_wildcard_ssl_cert --mode client`

To decrypt and store the vault stored on the server as json:

`knife decrypt vault selfsigned_wildcard_ssl_cert --mode client -Fj > selfsigned_wildcard_ssl_cert.json`

Gotcha #1: Expect chef-client runs on new servers to fail!  Because chef vault stores a list of clients and servers, when a new server is added you need to update that client list to include it with a 'knife encrypt update'.  My hope is this will get better in time.  This is a 'chicken before egg' problem right now.

`knife encrypt update vault selfsigned_wildcard_ssl_cert --search 'roles:base' --json ./selfsigned_wildcard_ssl_cert.json --admins admin,youruser,user1,user2 --mode client`

LDAP
====

Chef does not have much to do with any ldap support here aside from installing a php ldap library.  Below are just a few tips I'll share around openldap in particular: 

I run an openldap server on the same node that runs teampass and after installing Teampass 2.1.19 I go to the LDAP settings as admin and set them like this:

ldap server type: posix / openldap (rfc2307)
ldap base dn for your domain: dc=domain,dc=com
                              ou=People
                              uid
ldap array of domain controllers: localhost

With the above configuration an ldap authentication request is sent as uid=myusername,ou=People,dc=domain,dc=com which works for one of my configurations.  Enable debugging on your LDAP client/server to troubleshoot this further.

Unfortunately the first time a user logs in they will not be a members of any roles.  Give new users a default password, login to teampass once as them to create the local account stub, then with an admin account in the webui grant that user membership to the appropriate roles as you see fit, and they can change their password to a personal one through some other means (no support for Teampass password changes modifying ldap).

Upgrading
=========

Set the `[:teampass][version]` attribute as an `override_attribute` in a role like `examples/roles/teampass-server.json` to the desired version, upload it, and run chef-client on your Teampass server.  This will install the new files to a different directory and updates the 'current' symlink to point at the new version so your web browser then tracks the new version.

Run a mysqldump to save your data.  We will be running database schema updates shortly and its a good idea to get a snapshot in case we need to roll back to the old version which should be left behind.

Copy `includes/settings.php` and `secrets/secrets/sk.php` from the old Teampass version to the new version.  Also go through the `upload` directory to see if you need to copy any of those files over.  Take care to maintain file permissions and ownership when copying files over (they likely need to be writable by the apache2 user).

Go to `http://TEAMPASSITE/install/upgrade.php` and follow any instructions to update the database schema.

= BACKUPS:

Just be advised that there is a SALT value set during installation that is stored in the Teampass installations php files and is crucial for the encryption in the mysql database to function.  You cannot use a mysqldump restored teampass database if you don't have the same teampass installation with the correct SALT value.  This cookbook does not address backups.  This is just a tip for you to go think about backups.

License and Authors
===================
* Author:: Ian Garrison <garrison@technoendo.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
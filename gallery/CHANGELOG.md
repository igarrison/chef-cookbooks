# CHANGELOG for the gallery cookbook

This file is used to list changes made in each version of gallery.

## v0.1.2:

* Simplified the contrib-modules recipe to use a case statement instead of a lot of if statements from some feedback from Joshua Timberman.
* Tested on Debian 7

## v0.1.1:

* Default recipe split into smaller more modular and attribute driven recipes
* Gallery can be installed via git or standard http zip files, by changing a few attributes you can remove external dependancies like github and host the archives yourself
* The Gallery contrib modules and themes are mostly all installed by default.
* Contrib themes and module installation uses a simple LWRP 
* Switched to using 'database' cookbook provider for mysql db/user creation, 'git' cookbook for github repository work, and the 'ark' cookbook for http zip/tarball download and installation 
* Pushed all shell command file/permission tests, chmod, and chown operations into more portable ruby code
* Can switch between using ssl or not.  You can either skip any certificate management altogether, or rely on the 'certificate' cookbook which deploys certs/keys/chain files from encrypted data bags as documented here http://community.opscode.com/cookbooks/certificate (default is no ssl)
* Targetted testing and support of the 'ldap' contrib module used against an openldap server with anonymous bind.  It works but its fragile.  Gallery authentication breaks badly if everything is not perfect and its not very forgiving (deleting local user authentication to map ldap users to local users, but if ldap settings are not perfect authentication is badly broken).  Test and enable carefully!
* Bumped up gallery version to latest github 3.0.x branch build
* Delinted this cookbook with Food Critic
* Tested on Ubuntu 12.04, 12.10, and 13.04

## v0.1.0:

* Initial creation of the gallery cookbook from Pauly Comtois


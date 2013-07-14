# CHANGELOG for the gallery cookbook

This file is used to list changes made in each version of gallery.

## v0.1.1:

* Default recipe split into smaller more modular and attribute driven recipes
* Gallery can be installed via git or standard http zip files, by changing a few attributes you can remove external dependancies like github and host the archives in-house
* The Gallery contrib module and themes are installable, but be warned they are unsupportive and some combinations of modules behave badly
* Contrib themes and module installation uses a simple LWRP 
* Switched to using 'database' cookbook provider for mysql db/user creation, 'git' cookbook for github repository work, and the 'ark' cookbook for http zip/tarball download and installation 
* Pushed all shell command file/permission tests, chmod, and chown operations into more portable ruby code
* Can switch between using ssl or not, if yes you can either skip any certificate management done by this cookbook or rely on the 'certificate' cookbook which deploys certs/keys/chain files from encrypted data bags as documented here http://community.opscode.com/cookbooks/certificate (default is no ssl)
* Targetted testing and support of the 'ldap' contrib module used against an openldap server with anonymous bind.  It works but its fragile.  Gallery authentication breaks badly if everything is not perfect and its not very forgiving (deleting local user authentication to map ldap users to local users, but if ldap does not work authentication is badly broken.  Test and enable carefully.
* Bumped up gallery version to latest github 3.0.x branch build
* First time using Food Critic to delint a cookbook and encourage better practices
* Tested on Ubuntu 12.04, 12.10, and 13.04

## v0.1.0:

* Initial creation of the gallery cookbook from Pauly Comtois


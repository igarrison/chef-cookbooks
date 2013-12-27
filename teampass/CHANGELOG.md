# CHANGELOG for the teampass cookbook

This file is used to list changes made in each version of teampass.

## v0.1.0:

* certificate storage is done with chef-vault or left to the user
* added scripts based on self signed ssl cert generation process done by the sensu team to get quickly up and running, but still support commercial certs if you have them
* Recipe was split and made more modularized so folks can better enable/disable features with attributes.
* Delinted this cookbook with Food Critic
* Tested on Ubuntu 12.04, 12.10, and 13.04
* Pushed all shell command file/permission tests, chmod, and chown operations into more portable ruby code
* Switched from a execute driven database creation and user grants setup to using the 'database' cookbook to do this in a more elegant and cheffy way.
* Upgraded Teampass from 2.1.5 to 2.1.19

## v0.0.3:

* Initial creation of the teampass cookbook when I was first learning chef.  It was inelegant and not very cheffy but it worked.


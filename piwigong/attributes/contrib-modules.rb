default[:piwigo][:ldapmodule][:allgroups] = [ "Administrators", "Guest" ]
default[:piwigo][:ldapmodule][:everybody_group] = "Guest"
default[:piwigo][:ldapmodule][:regusergroup] = "Administrators"
default[:piwigo][:ldapmodule][:adminusers] = [ "joe", "bob" ]
default[:piwigo][:ldapmodule][:ldaphost] = "ldaps://ldap01.example.com/"
default[:piwigo][:ldapmodule][:groupdn] = "ou=Groups,dc=example,dc=com"
default[:piwigo][:ldapmodule][:userdn] = "ou=People,dc=example,dc=com"

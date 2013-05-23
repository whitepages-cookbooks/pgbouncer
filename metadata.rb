name             "pgbouncer"
provides         "pgbouncer"
maintainer       "Whitepages Inc."
maintainer_email "orichen@whitepages.com"
license          "Apache 2.0"
description      "Installs/Configures pgbouncer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"
recipe           "pgbouncer", "the default recipe does nothing to hopefully indicate that this is an LWRP cookbook"
recipe		 "pgbouncer::example", "this gives an example of how one could consume the pgbouncer cookbook"

%w{ubuntu}.each do |os|
  supports os
end
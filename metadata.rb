name             "pgbouncer"
provides         "pgbouncer"
maintainer       "Whitepages Inc."
maintainer_email "orichen@whitepages.com"
license          "Apache 2.0"
description      "Installs/Configures pgbouncer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"
recipe           "pgbouncer", "Example usage of pgbouncer resource"

%w{ubuntu}.each do |os|
  supports os
end

PGBouncer Cookbook
==================

This cookbook provides a [Chef LWRP](http://docs.opscode.com/lwrp.html) that sets up 
a basic [PGBouncer](http://wiki.postgresql.org/wiki/PgBouncer) connection pool that 
fronts a Postgresql database.  It has example configuration for integration on client machines,
exposing a local *nix socket that routes to a downstream database on another host.

Requirements
============

Chef 0.7+

Platform
--------

* Ubuntu (tested)
* Debian (should work but untested)
* RHEL, Centos, etc (untested)

Cookbooks
---------

It requires the 'apt' cookbook in order to function

Resources/Providers
===================

This exposes a single resource/provider pair, referred as `pgbouncer_connection`.  A basic 
example of it's use can be found in `recipes/example.rb`, but we'll outline it here too.

`pgbouncer_connection`
----------------------

Sets up and starts an Upstart service for pgbouncer, for the database alias you configure it for.

### Actions
- :setup: set up and configure a pgbouncer service for the database alias provided with included parameters (default action)
- :start: start a pgbouncer service for the database alias provided
- :stop: stop a pgbouncer service for the database alias provided
- :teardown: deletes the configuration files associated with the database alias provided

### Examples
    # setup and start a connection pool
    pgbouncer_connection "database_example_com_ro" do
      db_host "database.example.com"
      db_port "6432"
      db_name "test_database"
      userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # stop a connection pool
    pgbouncer_connection "database_example_com_ro" do
      action :stop
    end

    # TODO: include more examples

Recipes
=======

default
-------

This recipe is empty to hopefully help indicate that this is a resource-only cookbook.

example
-------

This recipe is here to give an example of how to use the resource, as well as the one that
gets exercised in the spec/ tests.

Testing
=======

This cookbook has been "Tested in Production"&trade;, but also has some basic RSpec tests
that can be executed.

**NOTE**: because Chef has cookbook naming expectations, the root repo expects to be in a folder
named 'pgbouncer'.

     bundle install
     bundle exec rake spec

Additionally, it's been run through Foodcritic to ensure we're at least not egregiously violating
something.

	bundle install
	bundle exec rake foodcritic

To see the installation end to end, we've also got a rake task that spins up a [chef-zero](https://github.com/jkeiser/chef-zero)
local instance, uploads the cookbooks via berkshelf, and spins up a vagrant instance that pulls the data down.  We use a stock
ubuntu cloud instance.

       bundle install
       bundle exec rake vagrant_startup

License and Author(s)
=====================

- Author:: Owyn Richen (<orichen@whitepages.com>)
- Author:: Jack Foy (<jfoy@whitepages.com>)
- Author:: Paul Kohan (<pkohan@whitepages.com>)
- Author:: Brian Engelman (<bengelman@whitepages.com>)

Copyright 2010-2013, [Whitepages Inc.](http://www.whitepages.com/)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

PGBouncer Cookbook [![Build Status](https://travis-ci.org/whitepages-cookbooks/pgbouncer.png?branch=master)](https://travis-ci.org/whitepages-cookbooks/pgbouncer)
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
Tested:
* Ubuntu

Untested:
* Debian (should work)
* RHEL, Centos, etc

Dependencies
---------

'apt' cookbook

Resources/Providers
===================

This cookbook exposes a single resource/provider pair, referred as `pgbouncer_connection`.  A basic 
example of its use can be found in `recipes/example.rb`, and is outlined below.

`pgbouncer_connection`
----------------------

Sets up an Upstart service for pgbouncer against a single database alias, then starts the service.
Multiple aliases may be supported on a single host.

### Actions
- :setup: configure a pgbouncer service for the specified database alias (default action)
- :start: start the configured pgbouncer service
- :stop: stop the configured pgbouncer service
- :teardown: delete the configuration (FIXME: may not be comprehensive)

### Examples
    # setup and start a read-only connection pool
    pgbouncer_connection "database_example_com_ro" do
      db_host "database.example.com"
      db_port "6432"
      db_name "test_database"
      userlist "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # setup and start a read-write connection pool
    pgbouncer_connection "database_example_com_rw" do
      db_host "database.example.com"
      db_port "6432"
      db_name "test_database"
      userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # setup and start a connection pool with database fallback (all databases)
    pgbouncer_connection "database_example_com_fallback" do
      db_host "database.example.com"
      db_port "6432"
      use_db_fallback true
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

Empty: this is a resource-only cookbook

example
-------

Example of how to use the resource; also exercised in the spec/ tests

Testing
=======

This cookbook has been "Tested in Production"&trade;, but also has some basic RSpec tests.

**NOTE**: because Chef 10 has cookbook naming expectations, the root repo expects to be in a folder
named 'pgbouncer'.

      bundle install
      bundle exec rake spec

The cookbook is clean under FoodCritic.

      bundle install
      bundle exec rake foodcritic

To see the installation end to end, we've also got a rake task that spins up a [chef-zero](https://github.com/jkeiser/chef-zero)
local instance, uploads the cookbooks via berkshelf, and spins up a vagrant instance that pulls the data down.  This is using a new
Vagrant plugin, created here at Whitepages, called [vagrant-chefzero](https://github.com/whitepages/vagrant-chefzero/).

      vagrant plugin install vagrant-chefzero
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

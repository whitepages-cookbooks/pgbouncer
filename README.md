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

This cookbook exposes a single resource/provider pair, referred as `pgbouncer_instance`.  A basic
example of its use can be found in `recipes/example.rb`, and is outlined below.

`pgbouncer_instance`
----------------------

Sets up an Upstart service for pgbouncer against a single database alias, then starts the service.
Multiple aliases may be supported on a single host.

### Actions
- :setup: configure a pgbouncer service for the specified databases (default action)
- :start: start the configured pgbouncer service
- :stop: stop the configured pgbouncer service
- :teardown: delete the configuration (FIXME: may not be comprehensive)

### Examples
    # Define all database aliases
    databases_list = [
      {
        db_alias: 'master',
        db_host: 'master.example.com',
        db_port: 6432,
        db_name: 'test_database'
      },
      {
        db_alias: 'replica',
        db_host: 'replica.example.com',
        db_port: 6432,
        db_name: 'test_database'
      }
    ]

    # setup and start a read-only connection pool
    pgbouncer_instance "example" do
      databases databases_list
      userlist "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # setup a read-write connection pool with different attributes
    pgbouncer_instance "example_attributes" do
      databases databases_list
      userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 50
      default_pool_size 10
      listen_addr '127.0.0.1'
      listen_port '15440'
      server_reset_query ''
      additional ({ ignore_startup_parameters: 'application_name,extra_float_digits'})
      action :setup
    end

    # stop a pgbouncer instance
    pgbouncer_instance "example" do
      action :stop
    end

    # start a pgbouncer instance
    pgbouncer_instance "example_attributes" do
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

Run ChefSpec unit tests

      bundle install
      rake spec

Run Kitchen tests

      bundle install
      rake kitchen

The cookbook is clean under Rubocop and FoodCritic.

      bundle install
      rake style

To see the installation end to end, you can use kitchen to converge and verify recipes [test kitchen](http://kitchen.ci/)
local instance, uploads the cookbooks via berkshelf, and spins up a kitchen instance that pulls the data down.

List available instances

      bundle install
      kitchen list

Converge an instance

      kitchen converge [instance name]

Run the tests

      kitchen verify [instance name]

Delete an instance

      kitchen destroy [instance name]

License and Author(s)
=====================

- Author:: Owyn Richen (<orichen@whitepages.com>)
- Author:: Jack Foy (<jfoy@whitepages.com>)
- Author:: Paul Kohan (<pkohan@whitepages.com>)
- Author:: Brian Engelman (<bengelman@whitepages.com>)
- Author:: Dorian Zaccaria (<dorian@datadoghq.com>)

Copyright 2010-2013, [Whitepages Inc.](http://www.whitepages.com/)

Copyright 2015, [Datadog Inc.](http://www.datadoghq.com/)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

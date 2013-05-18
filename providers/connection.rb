#
# Cookbook Name:: pgbouncer
# Provider:: connection
#
# Copyright 2010-2013, Whitepages Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def initialize(*args)
  super
  @action = :setup
end

action :start do
  service "pgbouncer-#{new_resource.db_alias}-start" do
    service_name "pgbouncer-#{new_resource.db_alias}" # this is to eliminate warnings around http://tickets.opscode.com/browse/CHEF-3694
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
  end
end

action :restart do
  service "pgbouncer-#{new_resource.db_alias}-restart" do
    service_name "pgbouncer-#{new_resource.db_alias}" # this is to eliminate warnings around http://tickets.opscode.com/browse/CHEF-3694
    provider Chef::Provider::Service::Upstart
    action [:enable, :restart]
  end
end

action :stop do
  service "pgbouncer-#{new_resource.db_alias}-stop" do
    service_name "pgbouncer-#{new_resource.db_alias}" # this is to eliminate warnings around http://tickets.opscode.com/browse/CHEF-3694
    provider Chef::Provider::Service::Upstart
    action :stop
  end
end

action :setup do

  group new_resource.group do

  end

  user new_resource.user do
    gid new_resource.group
    system true
  end

  # install the pgbouncer package
  #
  package 'pgbouncer' do
    action [:install, :upgrade]
  end

  service "pgbouncer-#{new_resource.db_alias}" do
    provider Chef::Provider::Service::Upstart
    supports :enable => true, :start => true, :restart => true
    action :nothing
  end

  # create the log, pid, db_sockets, /etc/pgbouncer, and application socket directories
  [
   new_resource.log_dir,
   new_resource.pid_dir,
   new_resource.socket_dir,
   ::File.expand_path(::File.join(new_resource.socket_dir, new_resource.db_alias)),
   '/etc/pgbouncer'
  ].each do |dir|
    directory dir do
      action :create
      recursive true
      owner new_resource.user
      group new_resource.group
      mode 0775
    end
  end

  # resources only surface defaults when actually hitting accessors
  # so we need to fetch them explicitly...
  # This is somewhat ugly and could break but Chef seems to generate
  # _set_or_return_* methods for every attribute, so iterating over
  # the methods seems to be the best way to find the declared attributes
  #
  properties = new_resource.methods.inject({}) do |memo, method|
    next memo unless method.to_s =~ /\_set\_or\_return_.*/

    property = method.to_s.gsub("_set_or_return_","")
    value = new_resource.send(property.to_sym)
    next memo if value.nil?

    memo[property] = value
    memo
  end

  # build the userlist, pgbouncer.ini, upstart conf and logrotate.d templates
  {
    "/etc/pgbouncer/userlist-#{new_resource.db_alias}.txt" => 'etc/pgbouncer/userlist.txt.erb',
    "/etc/pgbouncer/pgbouncer-#{new_resource.db_alias}.ini" => 'etc/pgbouncer/pgbouncer.ini.erb',
    "/etc/init/pgbouncer-#{new_resource.db_alias}.conf" => 'etc/init/pgbouncer.conf.erb',
    "/etc/logrotate.d/pgbouncer-#{new_resource.db_alias}" => 'etc/logrotate.d/pgbouncer-logrotate.d.erb'
  }.each do |key, source_template|
    ## We are setting destination_file to a duplicate of key because the hash
    ## key is frozen and immutable.
    destination_file = key.dup

    template destination_file do
      cookbook 'pgbouncer'
      source source_template
      owner new_resource.user
      group new_resource.group
      mode 0644
      notifies :restart, "service[pgbouncer-#{new_resource.db_alias}]"
      variables(properties)
    end
  end

  new_resource.updated_by_last_action(true)
end

action :teardown do

  { "/etc/pgbouncer/userlist-#{new_resource.db_alias}.txt" => 'etc/pgbouncer/userlist.txt.erb',
    "/etc/pgbouncer/pgbouncer-#{new_resource.db_alias}.ini" => 'etc/pgbouncer/pgbouncer.ini.erb',
    "/etc/init/pgbouncer-#{new_resource.db_alias}.conf" => 'etc/pgbouncer/pgbouncer.conf',
    "/etc/logrotate.d/pgbouncer-#{new_resource.db_alias}" => 'etc/logrotate.d/pgbouncer-logrotate.d'
  }.each do |destination_file, source_template|
    file destination_file do
      action :delete
    end
  end

  new_resource.updated_by_last_action(true)
end

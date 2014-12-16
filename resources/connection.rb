#
# Cookbook Name:: pgbouncer
# Resource:: connection
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

actions :setup, :teardown, :start, :restart, :stop
default_action :setup

attribute :db_alias, :kind_of => String, :name_attribute => true
attribute :db_host, :kind_of => String, :required => true
attribute :db_port, :kind_of => String, :required => true
attribute :db_name, :kind_of => String, :required => true

attribute :auth_type, :kind_of => String, :default => 'md5'
attribute :userlist, :kind_of => Hash, :required => true

attribute :listen_addr, :kind_of => String
attribute :listen_port, :kind_of => String

attribute :user, :kind_of => String, :default => 'pgbouncer'
attribute :group, :kind_of => String, :default => 'pgbouncer'
attribute :log_dir, :kind_of => String, :default => '/var/log/pgbouncer'
attribute :socket_dir, :kind_of => String, :default => '/etc/pgbouncer/db_sockets'
attribute :pid_dir, :kind_of => String, :default => '/var/run/pgbouncer'

attribute :pool_mode, :kind_of => String, :default => 'transaction'
attribute :max_client_conn, :kind_of => Integer, :default => 60
attribute :default_pool_size, :kind_of => Integer, :default => 30
attribute :min_pool_size, :kind_of => Integer, :default => 10
attribute :reserve_pool_size, :kind_of => Integer, :default => 5
attribute :server_idle_timeout, :kind_of => Integer, :default => 3600

attribute :server_reset_query, :kind_of => String
attribute :connect_query, :kind_of => String
attribute :tcp_keepalive, :kind_of => Integer
attribute :tcp_keepidle, :kind_of => Integer
attribute :tcp_keepintvl, :kind_of => Integer

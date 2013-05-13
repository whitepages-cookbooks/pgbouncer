#
# Cookbook Name:: pgbouncer
# Recipe:: example
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

# NOTE:
# This is an example of how to leverage the included resource

pgbouncer_connection "database_example_com_ro" do
  db_host "database.example.com"
  db_port "6432"
  db_name "test_database"
  userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
  max_client_conn 100
  default_pool_size 20
  action [:setup, :start]
end

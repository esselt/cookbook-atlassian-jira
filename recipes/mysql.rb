#
# Cookbook Name:: atlassian-jira
# Recipe:: mysql
#
# Copyright 2015, HiST AITeL
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

mysql2_chef_gem 'default' do
  action :install
end

unless node['mysql']['server_root_password']
  node.set['mysql']['server_root_password'] = ([nil]*24).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join
end

mysql_service 'default' do
  port '3306'
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

mysql_connection = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node['atlassian-jira']['mysql']['database'] do
  connection mysql_connection
  encoding 'utf8'
  collation 'utf8_bin'
  action :create
end

mysql_database_user node['atlassian-jira']['mysql']['user'] do
  connection mysql_connection
  password node['atlassian-jira']['mysql']['password']
  host '127.0.0.1'
  action :create
end

mysql_database_user node['atlassian-jira']['mysql']['user'] do
  connection mysql_connection
  password node['atlassian-jira']['mysql']['password']
  host '127.0.0.1'
  database_name node['atlassian-jira']['mysql']['database']
  privileges [:all]
  action :grant
end
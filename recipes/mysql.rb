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

node.set['atlassian-jira']['mysql']['root_password'] = ['atlassian-jira']['mysql']['root_password'] ||= 16.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join

mysql_service 'default' do
  port '3306'
  initial_root_password node['atlassian-jira']['mysql']['root_password']
  action [:create, :start]
end

mysql_connection = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => node['atlassian-jira']['mysql']['root_password']
}

mysql_database node['atlassian-jira']['mysql']['database'] do
  connection mysql_connection
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
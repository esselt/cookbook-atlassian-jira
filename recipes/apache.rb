#
# Cookbook Name:: atlassian-jira
# Recipe:: apache2
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

%w{apache2 apache2::mod_proxy_ajp}.each do |recipe|
  include_recipe recipe
end

if node['atlassian-jira']['apache']['ssl_enable']
  include_recipe 'apache2::mod_ssl'
end

web_app 'jira' do
  template 'web_app.erb'

  hostname node['atlassian-jira']['apache']['hostname']
  jira_host node['atlassian-jira']['apache']['jira_host']

  ssl_enable node['atlassian-jira']['apache']['ssl_enable']
  ssl_cert node['atlassian-jira']['apache']['ssl_cert']
  ssl_key node['atlassian-jira']['apache']['ssl_key']

  enable true
end
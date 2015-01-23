#
# Cookbook Name:: atlassian-jira
# Recipe:: jira
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

group 'jira' do
  gid directory node['atlassian-jira']['jira']['gid']
end

user 'jira' do
  uid directory node['atlassian-jira']['jira']['uid']
  gid directory node['atlassian-jira']['jira']['gid']
  home node['atlassian-jira']['jira']['data_dir']
  comment 'Atlassian JIRA'
end

directory node['atlassian-jira']['jira']['install_dir'] do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
end

directory node['atlassian-jira']['jira']['data_dir'] do
  owner 'jira'
  group 'jira'
  mode 00700
  recursive true
end

template "#{Chef::Config['file_cache_path']}/response.varfile" do
  source 'response.varfile.erb'
  mode 00600
  variables :settings => node['atlassian-jira']['jira']
end

installer_filename = ::File.basename(node['atlassian-jira']['jira']['installer_url'])
remote_file "#{Chef::Config['file_cache_path']}/#{installer_filename}" do
  source node['atlassian-jira']['jira']['installer_url']
  mode 00744
  action :create_if_missing
  notifies :run, 'execute[install-jira]'
end

execute 'install-jira' do
  command "./#{installer_filename} -q -varfile response.varfile"
  cwd Chef::Config['file_cache_path']
  action :nothing
end

cookbook_file 'mysql-connector-java-5.1.34.jar' do
  source "#{node['atlassian-jira']['jira']['installer_url']}/lib/mysql-connector-java-5.1.34.jar"
  owner 'root'
  group 'root'
  mode 00644
  notifies :run, 'execute[restart-jira]'
end

template "#{node['atlassian-jira']['jira']['data_dir']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner 'jira'
  group 'jira'
  mode 00640
  variables :settings => node['atlassian-jira']['mysql']
  notifies :run, 'execute[restart-jira]'
end

service 'jira' do
  command './stop-jira.sh && ./start-jira.sh'
  cwd "#{node['atlassian-jira']['jira']['installer_url']}/bin"
  action :nothing
end
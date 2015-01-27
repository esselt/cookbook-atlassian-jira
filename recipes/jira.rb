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

node.set['java'] = {
  'install_flavor' => 'oracle',
  'jdk_version' => '7',
  'oracle' => {
    'accept_oracle_download_terms' => true
  }
}
include_recipe 'java::default'

group 'jira' do
  gid node['atlassian-jira']['jira']['gid']
end

user 'jira' do
  uid node['atlassian-jira']['jira']['uid']
  gid node['atlassian-jira']['jira']['gid']
  home node['atlassian-jira']['jira']['data_dir']
  comment 'Atlassian JIRA'
end

directory node['atlassian-jira']['jira']['install_dir'] do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
end

directory 'jira-log-dir' do
  path "#{node['atlassian-jira']['jira']['install_dir']}/logs"
  owner 'jira'
  group 'root'
  mode 00755
end

directory 'jira-work-dir' do
  path "#{node['atlassian-jira']['jira']['install_dir']}/work"
  owner 'jira'
  group 'root'
  mode 00755
end

directory 'jira-temp-dir' do
  path "#{node['atlassian-jira']['jira']['install_dir']}/temp"
  owner 'jira'
  group 'root'
  mode 00755
end

directory node['atlassian-jira']['jira']['data_dir'] do
  owner 'jira'
  group 'jira'
  mode 00700
  recursive true
end

archive_filename = ::File.basename(node['atlassian-jira']['jira']['archive_url'])
remote_file "#{Chef::Config['file_cache_path']}/#{archive_filename}" do
  source node['atlassian-jira']['jira']['archive_url']
  mode 00744
  action :create
  notifies :run, 'execute[extract-jira]'
  not_if "test -f #{Chef::Config['file_cache_path']}/jira-installed"
end

execute 'extract-jira' do
  command "tar --no-same-owner -zxf #{archive_filename}"
  cwd Chef::Config['file_cache_path']
  action :nothing
  notifies :run, 'execute[move-jira]'
end

archive_folder = archive_filename.sub('.tar.gz', '') + '-standalone'
execute 'move-jira' do
  command "mv #{archive_folder}/* #{node['atlassian-jira']['jira']['install_dir']}"
  cwd Chef::Config['file_cache_path']
  action :nothing
  notifies :create, 'directory[jira-log-dir]'
  notifies :create, 'directory[jira-work-dir]'
  notifies :create, 'directory[jira-temp-dir]'
  notifies :run, 'execute[cleanup-jira]'
end

execute 'cleanup-jira' do
  command "rm -rf #{archive_folder}; rm -rf #{archive_filename}; touch jira-installed"
  cwd Chef::Config['file_cache_path']
  action :nothing
end

template '/etc/init.d/jira' do
  source 'jira.init.erb'
  owner 'root'
  group 'root'
  mode 00755
  variables :settings => node['atlassian-jira']['jira']
end

cookbook_file 'mysql-connector-java-5.1.34.jar' do
  path "#{node['atlassian-jira']['jira']['install_dir']}/lib/mysql-connector-java-5.1.34.jar"
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, 'service[jira]'
  only_if "test -d #{node['atlassian-jira']['jira']['install_dir']}/lib"
end

cookbook_file 'server.xml' do
  path "#{node['atlassian-jira']['jira']['install_dir']}/conf/server.xml"
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, 'service[jira]'
  only_if "test -d #{node['atlassian-jira']['jira']['install_dir']}/conf"
end

cookbook_file 'user.sh' do
  path "#{node['atlassian-jira']['jira']['install_dir']}/bin/user.sh"
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, 'service[jira]'
  only_if "test -d #{node['atlassian-jira']['jira']['install_dir']}/bin"
end

template "#{node['atlassian-jira']['jira']['data_dir']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner 'jira'
  group 'jira'
  mode 00640
  variables :settings => node['atlassian-jira']['mysql']
  notifies :restart, 'service[jira]'
end

template "#{node['atlassian-jira']['jira']['install_dir']}/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source 'jira-application.properties.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables :settings => node['atlassian-jira']['jira']
  notifies :restart, 'service[jira]'
  only_if "test -d #{node['atlassian-jira']['jira']['install_dir']}/atlassian-jira/WEB-INF/classes"
end

service 'jira' do
  supports [:start, :stop, :restart, :status]
  action :nothing
end
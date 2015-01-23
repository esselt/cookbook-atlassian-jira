#
# Cookbook Name:: atlassian-jira
# Attribute:: default
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

default['atlassian-jira']['jira']['installer_url'] = 'http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.3.14-x64.bin'
default['atlassian-jira']['jira']['http_port'] = 8080
default['atlassian-jira']['jira']['rmi_port'] = 8005
default['atlassian-jira']['jira']['data_dir'] = '/var/atlassian/application-data/jira'
default['atlassian-jira']['jira']['install_dir'] = '/opt/atlassian/jira'
default['atlassian-jira']['jira']['gid'] = 600
default['atlassian-jira']['jira']['uid'] = 600

default['atlassian-jira']['mysql']['database'] = 'jira'
default['atlassian-jira']['mysql']['user'] = 'jira'
default['atlassian-jira']['mysql']['password'] = 'PleaseChangeMe'
default['atlassian-jira']['mysql']['root_password'] = nil
default['atlassian-jira']['mysql']['host'] = '127.0.0.1'

default['atlassian-jira']['apache']['hostname'] = node['fqdn']
default['atlassian-jira']['apache']['jira_host'] = '127.0.0.1'
default['atlassian-jira']['apache']['ssl_enable'] = false
default['atlassian-jira']['apache']['ssl_cert'] = nil
default['atlassian-jira']['apache']['ssl_key'] = nil
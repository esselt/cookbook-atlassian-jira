name             'atlassian-jira'
maintainer       'Boye Holden'
maintainer_email 'boye.holden@hist.no'
license          'Apache 2.0'
description      'Installs and sets up Atlassian Jira'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe 'atlassian-jira::default', 'Installs Jira'

%w(ubuntu debian).each do |os|
  supports os
end

%w(apache2).each do |pkg|
  depends pkg
end

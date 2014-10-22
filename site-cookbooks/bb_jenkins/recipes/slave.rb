include_recipe 'java'
include_recipe "nodejs::nodejs_from_binary"

user 'jenkins' do
  comment 'Jenkins User'
  gid 'users'
  home '/var/lib/jenkins'
  shell '/bin/bash'
end

group 'jenkins' do
  members ['jenkins']
  action :create
end

directory '/var/lib/jenkins' do
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  action :create
end

directory '/var/lib/jenkins/.ssh' do
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  recursive true
  action :create
end

file '/var/lib/jenkins/.ssh/authorized_keys' do
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  content node[:jenkins][:public_key]
  action :create
end

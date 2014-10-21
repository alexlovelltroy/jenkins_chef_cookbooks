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

directory '/var/lib/jenkins/.ssh' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

file '/var/lib/jenkins/.ssh/authorized_users' do
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  content node[:jenkins][:public_key]
  action :create
end

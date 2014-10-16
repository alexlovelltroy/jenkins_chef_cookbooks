user 'jenkins' do
  comment 'Jenkins User'
  gid 'users'
  home '/home/jenkins'
  shell '/bin/bash'
end

file '/home/jenkins/.ssh/authorized_users' do
  owner 'jenkins'
  group 'jenkins'
  mode '0755'
  content node[:jenkins][:public_key]
  action :create
end

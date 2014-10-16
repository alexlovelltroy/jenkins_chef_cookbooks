include_recipe 'java'
include_recipe 'jenkins::master'

jenkins_password_credentials 'admin' do
  description 'Admin'
  password node[:jenkins][:password]
end

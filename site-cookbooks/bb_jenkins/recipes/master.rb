include_recipe 'java'
include_recipe 'jenkins::master'

directory "#{node[:jenkins][:master][:home]}/.ssh" do
  owner "#{node[:jenkins][:master][:user]}"
  group "#{node[:jenkins][:master][:group]}"
  mode '0755'
  recursive true
  action :create
end

file '/home/jenkins/.ssh/id_rsa' do
  owner "#{node[:jenkins][:master][:user]}"
  group "#{node[:jenkins][:master][:group]}"
  mode '0755'
  content node[:jenkins][:private_key]
  action :create
end

jenkins_password_credentials 'admin' do
  description 'Admin'
  password node[:jenkins][:password]
  notifies :restart, 'service[jenkins]'
end

%w[
  git
  thinBackup
  artifactdeployer
  github
  github-api
  github-oauth
  ghprb
  mailer
  parameterized-trigger
  s3
  ws-cleanup
  scm-sync-configuration
].each do |site|
  jenkins_plugin plugin do
    notifies :restart, 'service[jenkins]'
  end
end

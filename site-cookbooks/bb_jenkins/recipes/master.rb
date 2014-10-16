include_recipe 'java'
include_recipe 'jenkins::master'

directory "#{node[:jenkins][:master][:home]}/.ssh" do
  owner "#{node[:jenkins][:master][:user]}"
  group "#{node[:jenkins][:master][:group]}"
  mode '0755'
  recursive true
  action :create
end

file "#{node[:jenkins][:master][:home]}/.ssh/id_rsa" do
  owner "#{node[:jenkins][:master][:user]}"
  group "#{node[:jenkins][:master][:group]}"
  mode '0755'
  content node[:jenkins][:private_key]
  action :create
end

# Set the private key on the Jenkins executor
ruby_block 'set private key' do
  block { node.run_state[:jenkins_private_key] = node[:jenkins][:private_key] }
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
].each do |plugin|
  jenkins_plugin plugin do
    notifies :restart, 'service[jenkins]'
  end
end

include_recipe 'bb_jenkins::dependencies'
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
  mode '600'
  content node[:jenkins][:private_key]
  action :create
end

# TODO: If this is the first run, we need to create the admin user with a public key
# For now this was done on jenkins after it was installed and then we re-run this with success

# Set the private key on the Jenkins executor
ruby_block 'set private key' do
  block { node.run_state[:jenkins_private_key] = node[:jenkins][:private_key] }
end

jenkins_password_credentials 'admin' do
  description 'Admin'
  password node[:jenkins][:password]
  notifies :restart, 'service[jenkins]'
end

jenkins_private_key_credentials 'jenkins' do
  description 'Jenkins ssh'
  private_key node[:jenkins][:private_key]
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

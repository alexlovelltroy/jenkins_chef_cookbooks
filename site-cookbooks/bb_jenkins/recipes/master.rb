include_recipe 'java'
include_recipe 'jenkins::master'

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

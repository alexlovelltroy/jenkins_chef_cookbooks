include_recipe 'java'
include_recipe 'jenkins::master'

jenkins_password_credentials 'admin' do
  description 'Admin'
  password node[:jenkins][:password]
end

jenkins_plugin 'git'
jenkins_plugin 'thinBackup'
jenkins_plugin 'artifactdeployer'
jenkins_plugin 'github'
jenkins_plugin 'github-api'
jenkins_plugin 'github-oauth'
jenkins_plugin 'ghprb'
jenkins_plugin 'mailer'
jenkins_plugin 'parameterized-trigger'
jenkins_plugin 's3'
jenkins_plugin 'ws-cleanup'

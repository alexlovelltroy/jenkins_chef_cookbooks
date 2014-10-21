include_recipe 'java'
include_recipe 'jenkins::master'
include_recipe "nodejs::nodejs_from_binary"

nodejs_npm 'grunt'
nodejs_npm 'gulp'
nodejs_npm 'css-sprite'
nodejs_npm 'gulp-angular-templatecache'
nodejs_npm 'gulp-cached'
nodejs_npm 'gulp-changed'
nodejs_npm 'gulp-clean'
nodejs_npm 'gulp-concat'
nodejs_npm 'gulp-if'
nodejs_npm 'gulp-imagemin'
nodejs_npm 'gulp-inject'
nodejs_npm 'gulp-jshint'
nodejs_npm 'gulp-less'
nodejs_npm 'gulp-minify-css'
nodejs_npm 'gulp-ng-annotate'
nodejs_npm 'gulp-rename'
nodejs_npm 'gulp-sourcemaps'
nodejs_npm 'gulp-template'
nodejs_npm 'gulp-uglify'
nodejs_npm 'gulp-util'
nodejs_npm 'imagemin-pngcrush'
nodejs_npm 'jshint-stylish'
nodejs_npm 'merge-stream'
nodejs_npm 'npm'
nodejs_npm 'yargs'


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

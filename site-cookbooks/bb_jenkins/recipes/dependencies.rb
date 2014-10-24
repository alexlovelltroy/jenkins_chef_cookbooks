include_recipe 'java'
include_recipe "nodejs::nodejs_from_binary"

# The dependencies need to be local anyway.
nodejs_npm 'grunt'
nodejs_npm 'gulp'
nodejs_npm 'gulpfile-install'

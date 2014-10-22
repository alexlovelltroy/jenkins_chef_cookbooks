# Set the private key on the Jenkins executor
ruby_block 'set private key' do
  block { node.run_state[:jenkins_private_key] = node[:jenkins][:private_key] }
end

# This gets ran on jenkins master when new slaves are spawned
node[:opsworks][:layers][:jenkins_slave][:instances].each do |name, slave|
  if slave[:status] == "online"
    jenkins_ssh_slave name do
      description "#{name} slave"
      labels      ['executor']
      host        slave[:ip]
      user        'jenkins'
      remote_fs   '/var/lib/jenkins'
      credentials 'admin'
    end
  end
end

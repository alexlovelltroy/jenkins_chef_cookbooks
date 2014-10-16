# This gets ran on jenkins master when new slaves are spawned
node[:opsworks][:layers][:jenkins_slave][:instances].each do |name, slave|
  if slave[:status] == "online"
    jenkins_ssh_slave name do
      description "#{name} slave"
      labels      ['executor']
      host        slave[:ip]
      user        'jenkins'
    end
  end
end

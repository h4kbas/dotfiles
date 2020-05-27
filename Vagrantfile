Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder "workspace/", "/home/vagrant/workspace"

  config.vm.provider "virtualbox" do |v|
    v.name = "dev_machine"
    v.memory = 1024
    v.cpus = 1
  end

  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y 
  # SHELL
end

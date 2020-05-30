# <projectname> development image
Vagrant.configure("2") do |config|
  # Base box image  
  config.vm.box = "ubuntu/trusty64"
  # Network config
  config.vm.network "private_network", type: "dhcp"
  # Mounted folders to the host machine
  config.vm.synced_folder "workspace/", "/home/vagrant/workspace"
  config.vm.synced_folder "ssh/", "/home/vagrant/.ssh", create: true
  # Hardware config
  config.vm.provider "virtualbox" do |v|
    v.name = "dev_machine"
    v.memory = 1024
    v.cpus = 1
  end

  # Shell commands to provision
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y 
  # SHELL
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
 config.vm.define "ubuntu" do |ubuntu|
  ubuntu.vm.box = "ubuntu/bionic64"
  ubuntu.vm.network "forwarded_port", guest: 80, host: 8080
  ubuntu.vm.network "private_network", ip: "192.168.60.70"
  ubuntu.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
		 vb.name = "ubuntu"
  end
	ubuntu.vm.provision "shell", path: "scripts/init.sh"
	end
end

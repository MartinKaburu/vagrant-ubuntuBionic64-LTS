# vagrant-ubuntuBionic64-LTS
Spin an ubuntu bionic LTS server with vagrant and provision it with shell
### Start the VM
`$ vagrant up`
### Provision the VM
`$ vagrant provision`
### SSH into the VM
run `$ vagrant ssh-config` to get the path to your PRIVATE_KEY

`$ ssh -i $PATH_TO_PRIVATE_KEY vagrant@192.168.60.70` || `$ vagrant ssh`

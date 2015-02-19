# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  #config.vm.synced_folder ".", "/project", :owner => "vagrant", :group => "vagrant", :mount_options => ['dmode=777,fmode=777']
  # "." mounted on /vagrant by default

  config.vm.network :forwarded_port, guest: 8983, host: 8983, auto_correct: true
  config.vm.network :forwarded_port, guest: 5000, host: 5000, auto_correct: true
  config.vm.network :private_network, ip: "192.168.33.20"
  
  config.ssh.forward_agent = true

  config.vm.box = "fedora20"

  config.vm.box_url = "https://dl.dropboxusercontent.com/u/15733306/vagrant/fedora-20-netinst-2014_01_05-minimal-puppet-guestadditions.box"

  config.vm.provider :virtualbox do |vb|
     vb.name = "solr"
     vb.customize ["modifyvm", :id, "--memory", "2024"]
  end

  config.vm.provision :puppet, :module_path => "provisioning/modules", run: "always" do |puppet|
    puppet.hiera_config_path = "provisioning/hiera.yaml"
    puppet.manifests_path    = "provisioning/manifests"
    puppet.manifest_file     = "development.pp"
    # puppet.options = "--verbose --debug"
  end

end

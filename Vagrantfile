# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.synced_folder "provisioning", "/tmp/puppet/provisioning"
  config.vm.synced_folder ".", "/project", :owner => "vagrant", :group => "vagrant", :mount_options => ['dmode=777,fmode=777']


  config.vm.network :forwarded_port, guest: 8983, host: 8983, auto_correct: true
  config.vm.network :private_network, ip: "192.168.33.20"
  
  config.ssh.forward_agent = true

  # Create a generated file with the ssh developers own key, for installation
  # by puppet into the VM.
#  local_developer_authorized_keys_filename = File.join(File.dirname(__FILE__),"provisioning/files/local_developer.authorized_keys")

#  local_developer_public_keys = %x{ssh-add -L}
#  case local_developer_public_keys
#  when /^ssh-/ then
#    File.open(local_developer_authorized_keys_filename,"w+"){|file|file.write local_developer_public_keys}
#  else
#    puts %{You must have a local ssh key, that is available to 'ssh-add -L'.}
#    exit 1
#  end


  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "box-cutter/fedora20"
  #config.vm.box = "centos65"
  config.vm.box = "fedora20"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  #config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140311.box"
  #config.vm.hostname = "localhost.localdomain"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/15733306/vagrant/fedora-20-netinst-2014_01_05-minimal-puppet-guestadditions.box"

  config.vm.provider :virtualbox do |vb|
     #vb.gui = true
     vb.name = "solr"
     vb.customize ["modifyvm", :id, "--memory", "2024"]
  end

  config.vm.provision :puppet, :module_path => "provisioning/modules" do |puppet|
    puppet.manifests_path = "provisioning/manifests"
    puppet.manifest_file  = "development.pp"
    # puppet.hiera_config_path = "provisioning"
    # puppet.options = "--verbose --debug"
  end

end

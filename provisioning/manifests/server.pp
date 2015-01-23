# http://projects.puppetlabs.com/projects/1/wiki/File_Permission_Check_Patterns

define check_mode($mode) {
  exec { "/bin/chmod $mode $name":
    unless => "/bin/sh -c '[ $(/usr/bin/stat -c %a $name) == $mode ]'",
  }
}

node default {

  class { "timezone": 
    region => "Europe", 
    locality => "Oslo",    
  }      
    
  Exec {
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    require => Class["timezone"]
  }
    
  group { "puppet":
     ensure => "present"
  }
  
  exec { "fusion":
    command => "rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm", 
    unless => "rpm -qa | grep rpmfusion"
  }


  package { ["wget", "curl", "make", "yum-utils", "dos2unix", "patch", "texlive", "latex2html","ruby-devel"]:
    ensure => present,
    require => Exec["fusion"]
  }  

#  package { ["rails",]:
#    ensure => present,
#    provider => gem,
#    require => Package["ruby-devel"]
#  }

#  file {
#    "/etc/hosts":
#       source => "/tmp/puppet/provisioning/files/hosts",
#       mode => 644,
#       owner => root,
#       group => root
#  }

  file { "/home/vagrant/.bash_profile":
    source => "/tmp/puppet/provisioning/files/bash_profile",
    mode => 644,
    owner => "vagrant",
    group => "vagrant"
  } 

  service { "iptables":
    ensure => "stopped"
  }  

#  file { '/var/www/html/plots':
#    ensure => 'directory',
#    owner => 'swan',
#    group => 'users'
#  }

  include solr

      
  

}

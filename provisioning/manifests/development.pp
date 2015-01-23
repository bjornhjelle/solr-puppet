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
  
#  exec { "fusion":
#    command => "rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm", 
#    unless => "rpm -qa | grep rpmfusion"
#  }


  package { ["wget", "curl", "make", "lsof"]:
    ensure => present
  }    

#  package { ["rails",]:
#    ensure => present,
#    provider => gem,
#    require => Package["ruby-devel"]
#  }


  file {
    "/etc/hosts":
       source => "/tmp/puppet/provisioning/files/hosts",
       mode => 644,
       owner => root,
       group => root
  }



#  service { "iptables":
#    ensure => "stopped"
#  }  

#  service { "firewalld":
#    ensure => "stopped"
#  }  
  
  include solr_development
  
#  notice("For å starte Solr:")
#  notify{"$ vagrant ssh":}
#  alert("$ solr start -f")
  

  
}

# http://projects.puppetlabs.com/projects/1/wiki/File_Permission_Check_Patterns

#define check_mode($mode) {
#  exec { "/bin/chmod $mode $name":
#    unless => "/bin/sh -c '[ $(/usr/bin/stat -c %a $name) == $mode ]'",
#  }
#}

node default {

#  class { "timezone": 
#    region => "Europe", 
#    locality => "Oslo",    
#  }      
    
  Exec {
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    #require => Class["timezone"]
  }
    
#  group { "puppet":
#     ensure => "present"
#  }
#  
#  exec { "fusion":
#    command => "rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm", 
#    unless => "rpm -qa | grep rpmfusion"
#  }


  package { ["wget", "curl", "make"]:
    ensure => present
  }  

  include solr_server

      
  

}

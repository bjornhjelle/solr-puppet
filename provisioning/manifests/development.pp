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

  package { ["wget", "curl", "make", "lsof"]:
    ensure => present
  }    

  file {
    "/etc/hosts":
       source => "/tmp/puppet/provisioning/files/hosts",
       mode => 644,
       owner => root,
       group => root
  }
  
  include solr_development

  
}

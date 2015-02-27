

node default {

     
    
  Exec {
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }
    

  package { ["wget", "curl", "make"]:
    ensure => present
  }  

  include solr_server

  class { "solr": 
      user => "solr", 
      group => "solr",
	  home_dir => "/home/solr"    
  }
  

}

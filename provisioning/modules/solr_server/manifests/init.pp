

class solr_server {

  file { "/home/solr/.bash_profile":
    source => "puppet:///modules/solr_server/bash_profile",
    mode => 644,
    owner => "solr",
    group => "solr"
  } 
  
  file { 'index_directory':
    path => '/opt/solr_indexes',
    ensure => 'directory',
    owner => 'solr',
    group => 'solr',
    mode => 755,
  } 
  
#  check_mode { "/opt/solr_indexes":
#    mode => 755,
#    require => File["index_directory"]
#  }
  
  file { 'log_directory':
    path => '/var/log/solr',
    ensure => 'directory',
    owner => 'solr',
    mode => 755,
    group => 'solr'
  } 
  
  file { 'distr':
    path => ['/home/solr/distr'],
    ensure => 'directory',
    owner => 'solr',
    mode => 755,
    group => 'solr'
  }
      
  exec { "get and unpack solr":
    command => "wget http://apache.vianett.no/lucene/solr/4.10.3/solr-4.10.3.tgz -P distr; tar xzf distr/solr-4.10.3.tgz -C distr",
    cwd => "/home/solr",
    user => "solr",
    group => "solr",
    creates => "/home/solr/distr/solr-4.10.3",
    require => File["distr"]
 }

  file { '/home/solr/solr':
   ensure => 'link',
   target => '/home/solr/distr/solr-4.10.3',
   require => Exec["get and unpack solr"]
 }

  file { "/home/solr/solr/example/resources/log4j.properties":
    source => "puppet:///modules/solr_server/log4j.properties",
    mode => 644,
    owner => "vagrant",
    group => "vagrant"
  }  
    
#  
#  file { "/etc/init.d/solr":
#    ensure => present,
#    source => 'puppet:///modules/solr/solr',
#    owner => "root",
#    group => "root",
#    mode => 755,
#    require => Exec["get and unpack solr"]
#  } 

#  exec {"chkconfig solr":
#    command => "chkconfig --add solr",
#    require => File["/etc/init.d/solr"]
#  }
  
}

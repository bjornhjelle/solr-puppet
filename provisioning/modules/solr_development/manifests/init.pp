

class solr_development {

  file { "/home/vagrant/.bash_profile":
    source => "puppet:///modules/solr_development/bash_profile",
    mode => 644,
    owner => "vagrant",
    group => "vagrant"
  } 
  

  file { 'indexes':
    path => ['/home/vagrant/indexes'],
    ensure => 'directory',
    owner => 'vagrant',
    mode => 755,
    group => 'vagrant'
  } 
  
  file { 'distr':
    path => ['/home/vagrant/distr'],
    ensure => 'directory',
    owner => 'vagrant',
    mode => 755,
    group => 'vagrant'
  }
  
  file { 'logs':
    path => ['/home/vagrant/logs'],
    ensure => 'directory',
    owner => 'vagrant',
    mode => 755,
    group => 'vagrant'
  }    

  exec { "get and unpack solr":
    command => "wget http://apache.vianett.no/lucene/solr/4.10.3/solr-4.10.3.tgz -P distr; tar xzf distr/solr-4.10.3.tgz -C distr",
    cwd => "/home/vagrant",
    user => "vagrant",
    group => "vagrant",
    creates => "/home/vagrant/distr/solr-4.10.3",
    require => File["distr"]
  }


  file { "/home/vagrant/solr/example/resources/log4j.properties":
    source => "puppet:///modules/solr_development/log4j.properties",
    mode => 644,
    owner => "vagrant",
    group => "vagrant"
  }
  
  file { "/home/vagrant/solr_home/collection1/core.properties":
    source => "puppet:///modules/solr_development/core.properties",
    mode => 644,
    owner => "solr",
    group => "solr"
  }
    
  file { '/home/vagrant/solr':
   ensure => link,
   target => '/home/vagrant/distr/solr-4.10.3',
   require => Exec["get and unpack solr"]
  }
 
  file { '/home/vagrant/solr_home':
    ensure => link,
    target => '/project/solr_home'
  }
    
  exec { "allow access to port 8983":
    command => "firewall-cmd --permanent --zone=public --add-port=8983/tcp",
    require => Exec["get and unpack solr"]
  }
  
  exec {"restart firewalld":
    command => "systemctl restart firewalld.service",
    require => Exec["allow access to port 8983"]
  }
   
  
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

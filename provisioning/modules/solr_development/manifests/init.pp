

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
    owner => "vagrant",
    group => "vagrant"
  }
  
      
  file { '/home/vagrant/solr':
   ensure => link,
   target => '/home/vagrant/distr/solr-4.10.3',
   require => Exec["get and unpack solr"]
  }

  file { "/etc/init.d/solr":
    ensure => present,
    source => 'puppet:///modules/solr_development/solr_startup',
    owner => "root",
    group => "root",
    mode => 755,
    require => File["/home/vagrant/solr_home/collection1/core.properties"]
  }  

  file { '/home/vagrant/solr_home':
    ensure => link,
    target => '/project/solr_home'
  }

  file { '/home/vagrant/www':
    ensure => link,
    target => '/project/www'
  }

  file { "/home/vagrant/solr/example/contexts/www.xml":
    source => "puppet:///modules/solr_development/www.xml",
    mode => 644,
    owner => "vagrant",
    group => "vagrant",
    require => [File["/home/vagrant/www"],Exec["get and unpack solr"]]
  }

  exec { "allow access to port 8983":
    command => "firewall-cmd --permanent --zone=public --add-port=8983/tcp",
    require => Exec["get and unpack solr"]
  }
  
  exec {"restart firewalld":
    command => "systemctl restart firewalld.service",
    require => Exec["allow access to port 8983"]
  }

  exec {"chkconfig solr":
    command => "chkconfig solr on",
    require => File["/etc/init.d/solr"]
  }

  exec {"restart solr":
    #command => "systemctl restart solr",
    command => "/sbin/service solr restart",
    require => File["/etc/init.d/solr"]
 
  
 
}

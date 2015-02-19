class solr($user = 'solr', $group = 'solr', $home_dir = '/home/solr') {

  file { "${home_dir}/.bash_profile":
    #source => "puppet:///modules/solr/bash_profile",
	content => template('solr/bash_profile.erb'),
    mode => 644,
    owner => $user,
    group => $group
  } 
  

  file { 'indexes':
    path => ["${home_dir}/indexes"],
    ensure => 'directory',
    owner => $user,
    group => $group,
    mode => 755
  } 
  
  file { 'distr':
    path => ["${home_dir}/distr"],
    ensure => 'directory',
    owner => $user,
    group => $group,
    mode => 755
  }
  
  file { 'logs':
    path => ["${home_dir}/logs"],
    ensure => 'directory',
    owner => $user,
    group => $group,
    mode => 755
  }    

  exec { "get and unpack solr":
    command => "wget http://apache.vianett.no/lucene/solr/4.10.3/solr-4.10.3.tgz -P distr; tar xzf distr/solr-4.10.3.tgz -C distr",
    cwd => $home_dir,
    user => $user,
    group => $group,
    creates => "${home_dir}/distr/solr-4.10.3",
    require => File["distr"]
  }

  file { "${home_dir}/solr/example/resources/log4j.properties":
    #source => "puppet:///modules/solr/log4j.properties",
	content => template('solr/log4j.properties.erb'),
    owner => $user,
    group => $group,
    mode => 644
  }
  
  file { "${home_dir}/solr_home/collection1/core.properties":
    #source => "puppet:///modules/solr/core.properties",
	content => template('solr/core.properties.erb'),
    owner => $user,
    group => $group,
    mode => 644
  }
  
      
  file { "${home_dir}/solr":
   ensure => link,
   target => "${home_dir}/distr/solr-4.10.3",
   require => Exec["get and unpack solr"]
  }

  file { "/etc/init.d/solr":
    ensure => present,
    #source => 'puppet:///modules/solr/solr_startup',
	content => template('solr/solr_startup.erb'),
    owner => "root",
    group => "root",
    mode => 755,
    require => File["${home_dir}/solr_home/collection1/core.properties"]
  }  



  file { "${home_dir}/solr/example/contexts/www.xml":
    #source => "puppet:///modules/solr/www.xml",
	content => template('solr/www.xml.erb'),
    mode => 644,
    owner => $user,
    group => $group,
    require => [File["${home_dir}/www"],Exec["get and unpack solr"]]
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
    require => Exec["restart firewalld"]
  }

  exec {"restart solr":
    command => "/sbin/service solr restart",
    require => Exec["chkconfig solr"]
  }
  
 
}

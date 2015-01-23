

class solr {

  exec { "add-solr-user": 
    command => "useradd solr -G admin",
    creates => "/home/solr"
  }
  
  check_mode { "/home/solr":
    mode => 755,
  }
  
  file {"/home/solr/.ssh":
    ensure => "directory",
    owner   => "solr",
    group   => "solr",
    mode    => 755,
    require => Exec["add-solr-user"]
  }  
  
  file { "/home/solr/.ssh/authorized_keys":
    source => "/tmp/puppet/provisioning/files/local_developer.authorized_keys",
    mode => 644,
    owner => "solr",
    group => "solr",
    require => File["/home/solr/.ssh"]
  }

  file { "/home/solr/.bash_profile":
    source => "puppet:///modules/solr/bash_profile",
    mode => 644,
    owner => "solr",
    group => "solr",
    require => Exec["add-solr-user"]
  } 
  
  file { 'index_directory':
    path => '/opt/solr_indexes',
    ensure => 'directory',
    owner => 'solr',
    group => 'solr',
    require => Exec["add-solr-user"]
  } 
  
  check_mode { "/opt/solr_indexes":
    mode => 755,
    require => File["index_directory"]
  }

  exec { "get and unpack solr":
    command => "wget http://apache.vianett.no/lucene/solr/4.10.3/solr-4.10.3.tgz; tar xzf solr-4.10.3.tgz",
    cwd => "/home/solr",
    user => "solr",
    group => "solr",
    creates => "/home/solr/solr-4.10.3",
    require => Exec["add-solr-user"]
 }
#  file { '/var/www/html/plots':
#    ensure => 'directory',
#    owner => 'swan',
#    group => 'users'
#  }

  file { '/home/solr/solr':
   ensure => 'link',
   target => '/home/solr/solr-4.10.3',
   require => Exec["get and unpack solr"]
 }
  
  
  file { "/etc/init.d/solr":
    ensure => present,
    source => 'puppet:///modules/solr/solr',
    owner => "root",
    group => "root",
    mode => 755,
    require => Exec["get and unpack solr"]
  } 

  exec {"chkconfig solr":
    command => "chkconfig --add solr",
    require => File["/etc/init.d/solr"]
  }
  
}

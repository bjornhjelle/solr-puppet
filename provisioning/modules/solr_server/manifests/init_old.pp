

class solr_user {

  exec { "add-solr-user": 
    command => "useradd solr",
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
  
  file { "/home/swan/.solr/authorized_keys":
    source => "/tmp/puppet/provisioning/files/local_developer.authorized_keys",
    mode => 644,
    owner => "solr",
    group => "solr",
    require => File["/home/solr/.ssh"]
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


  
}

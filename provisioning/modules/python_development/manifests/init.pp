

class python_development {

  package { ["python-pip"]:
    ensure => present
  }
  
  # http://flask.pocoo.org/
  exec { "flask":
    command => "sudo pip install flask",
    require => Package["python-pip"]
  }
  
  # http://jinja.pocoo.org/
  exec { "jinja2":
    command => "sudo pip install jinja2",
    require => Package["python-pip"]
  }


  exec { "requests":
    command => "sudo pip install requests httplib2",
    require => Package["python-pip"]
  }
  
    
  exec { "allow access to port 5000":
    command => "firewall-cmd --permanent --zone=public --add-port=5000/tcp && systemctl restart firewalld.service"
  }

  
     
}

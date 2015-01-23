# Solr, install with puppet #

Scripts to install Solr 4.10.3 using puppet. Two ways to install are implemented:

 1. in a Linux VM (Fedora 20)
 2. on a Linux machine (tested on Fedora 20)

Solr is installed with Solr home, logs-directory and indexes outside of the Solr-distribution to make it easy to change to another release of Solr. 

## Getting started ##
Before installing in a VM you must have installed:

* Ruby
* Vagrant
* VirtualBox

To install on a Linux machine you must have installed:

* Ruby
* Puppet

Then clone the repository: 

    git clone ...
    
## Solr in a VM ##

To install Solr in a VM

    cd solr-puppet
    vagrant up

### Start Solr ###

Log in to the VM and start Solr

    vagrant ssh
    solr start

This uses the script that comes with the Solr distribution to start/stop Solr. Read more [here](https://cwiki.apache.org/confluence/display/solr/Running+Solr).

The Solr admin interface can now be reached using URL: <http://localhost:8983/solr>

### To add content ###
On the host machine: 

    cd sampledocs
    ./post.sh solr.xml
    
And verify that the document was indexed:
<http://localhost:8983/solr/collection1/select?q=*%3A*&wt=json&indent=true>

Or use the full set of example docs available in the VM:

    vagrant ssh
    cd solr/example/exampledocs
    ./post.sh hd.xml 

### File locations ###

* Indexes will be stored in `/home/vagrant/indexes`
* Log files will be stored in `/home/vagrant/logs`
* Solr home is the directory `/home/vagrant/solr_home` (based on the example home i the distribution: `example/solr`)

## Solr on a Linux machine ##

To install, first add the linux user to run solr, set a password, and log in as `solr`: 
  
    useradd solr
    passwd solr 
    su - solr

Then clone and apply puppet manifest:

    git clone https://github.com/bjornhjelle/solr-puppet.git
    cd solr-puppet
    sudo puppet apply --modulepath provisioning/modules provisioning/manifests/server.pp

Log out and back in to set environment variable, and then start Solr: 

    solr start -f 
    
    
    



#
# = Definition: containters::instance
#
# runs lxc instance
# Params:
#	- $customer - with appname is used to make lxc name
#	- $appname - as above
#	- $apptype - which lxc template use: 
#									* lamp_fcgi_php
#									* standard
#	- $ip - ip number used by container
#

define containers::instance( $customer, $appname, $apptype, $ip) {

	include containers
    
    $lxcdir = '/var/lib/lxc'
	containers::create { "create_${customer}-${appname}":
		customer => $customer,
		appname => $appname,
		apptype => $apptype,
		ip => $ip,
	}


    file { "/etc/lxc/auto/${customer}-${appname}":
        ensure => link,
        target => "${lxcdir}/${customer}-${appname}/config",
		require => Containers::Create["create_${customer}-${appname}"],
        notify => Class["containers::reload"],
    }

#    #reload of lxc should be executed only when new configuration is created
#    # reload is fired as last class, this is the way to mark new
#    # condition, because we don't know if any definition has been executed
#    file { "/etc/lxc/auto/new":
#        ensure => present,
#        content => "",
#    }

}
	
#create repo -> gitolite::addrepo(reponame=${customer}-${appname})
#create varnish instance

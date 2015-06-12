define revproxy::vhost ($customer, $appname, $domain, $backendip, $vhost_aliases) {
	
	file { "/etc/apache2/sites-enabled/revproxy_config_${customer}-${appname}.conf":
		ensure => present,
		content => template("revproxy/revproxy_vhost_config.erb"),
		require => Class["revproxy::service"],
	}
	
	exec { "reload_after_revproxy_config_${customer}-${appname}":
		refreshonly => true,
		subscribe => File["/etc/apache2/sites-enabled/revproxy_config_${customer}-${appname}.conf"],
		command => "/usr/bin/service apache2 reload",
	}

}

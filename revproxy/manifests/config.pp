class revproxy::config {

	if $fqdn == 'ple.net' {
		$webcache = ''
	} else {
		$webcache = 'net'
	}

	exec { "enable_proxy":
		command => "/usr/sbin/a2enmod http_proxy",
		refreshonly => true,
		subscribe => Class["revproxy::install"],
	}

	exec { "restart_apache":
		command => "/usr/bin/service apache2 restart",
		refreshonly => true,
		subscribe => Exec["enable_proxy"],
	}

}

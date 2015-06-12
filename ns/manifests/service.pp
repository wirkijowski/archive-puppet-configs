
class ns::service {

	service { "bind9":
		ensure => running,
		require => Class["ns::config"],
	}

	exec { "bind9_restart":
		command => "/usr/sbin/service bind9 restart",
		subscribe => File["/etc/bind/named.conf.local",
		"/etc/bind/named.conf.options"],
	}
	
	exec { "rndc_reload":
		command => "/usr/sbin/rndc reload",
		subscribe => File["/var/cache/bind"],
	}
	Exec {
		refreshonly => true,
		require => Service["bind9"],
	}
}

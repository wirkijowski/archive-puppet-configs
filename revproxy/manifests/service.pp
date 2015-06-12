
class revproxy::service {
	service { "apache2":
		ensure => running,
		require => Class["revproxy::config"],
	}
}

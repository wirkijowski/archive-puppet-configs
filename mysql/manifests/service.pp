class mysql::service {
	service { "mysql":
		ensure => running,
	   	hasstatus => true,
		hasrestart => true,
		provider => "debian",
		require => Class["mysql::config"],
	}
}


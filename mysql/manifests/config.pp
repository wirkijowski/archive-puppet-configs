class mysql::config {
	File {
		ensure => present,
		require => Class["mysql::install"],
		mode => 0644,
		owner => "mysql",
		group => "mysql",
	}

	file { "/etc/mysql/my.cnf":
	   	source => "puppet:///modules/mysql/my.cnf",
	}

	file { "/etc/mysql/x.crt":
		source => "puppet:///modules/mysql/",
	}

	file { "/etc/mysql/ca.crt":
		source => "puppet:///modules/mysql/",
	}

	file { "/etc/mysql/x.key":
		source => "puppet:///modules/mysql/x.key",
		mode => 0600
	}



}


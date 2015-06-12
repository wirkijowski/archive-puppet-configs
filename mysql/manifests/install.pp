class mysql::install {
	$password = ''
	package { ["mysql-client", "mysql-server", "mysql-common"]:
		ensure => installed
	}

	exec { "Set MySQL server root password":
		subscribe => Package["mysql-client", "mysql-server", "mysql-common"],
		refreshonly => true,
		unless => "mysqladmin -uroot -p\'$password\' status",
		path => "/bin:/usr/bin",
		command => "mysqladmin -uroot password \'$password\'",
	}

}


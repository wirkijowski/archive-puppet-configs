class revproxy::install {

	package { "apache2":
		ensure => present,
		provider => apt,
	}
}

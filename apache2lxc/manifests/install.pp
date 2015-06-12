class apache2lxc::install {

	package { ["apache2-mpm-prefork", "apache2-suexec", "libapache2-mod-fastcgi","libapache2-mod-php5"]:
		ensure => present,
		provider => apt,
	}
}

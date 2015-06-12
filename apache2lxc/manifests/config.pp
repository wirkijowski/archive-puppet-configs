class apache2lxc::config {
	file { "/etc/apache2/sites-enabled":
		ensure => directory,
		recurse => true,
		source => "puppet:///files/apache2lxc/${hostname}",
	}

	file { "/etc/apache2/sites-enabled/000-default":
		ensure => absent,
	}

	exec { "reload_apache":
		command => "/usr/bin/service apache2 reload",
		refreshonly => true,
		subscribe => File["/etc/apache2/sites-enabled",	"/etc/apache2/sites-enabled/000-default" ],
	}

	$modsavail = "../mods-available"
	$modsenabl = "/etc/apache2/mods-enabled"

	file { "${modsenabl}/actions.conf" :
		ensure => link,
		target => "${modsavail}/actions.conf",
	}

	file { "${modsenabl}/actions.load" :
		ensure => link,
		target => "${modsavail}/actions.load",
	}
	file { "${modsenabl}/suexec.load" :
		ensure => link,
		target => "${modsavail}/suexec.load",
	}
	file { "${modsenabl}/fastcgi.conf" :
		ensure => link,
		target => "${modsavail}/fastcgi.conf",
	}
	file { "${modsenabl}/fastcgi.load" :
		ensure => link,
		target => "${modsavail}/fastcgi.load",
	}
	file { "${modsenabl}/rewrite.load":
		ensure => link,
		target => "${modsavail}/rewrite.load",
	}

	File {
		require => Class["apache2lxc::install"],
	}
}

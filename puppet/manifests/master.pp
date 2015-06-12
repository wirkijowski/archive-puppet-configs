class puppet::master {
	include puppet
#	include puppet::params

	package { "puppetmaster":
			ensure => installed,
			provider => apt,
			require => Class["puppet::install"],
	}

	service { "puppetmaster":
			ensure => running,
			hasstatus => true,
			hasrestart => true,
			enable => true,
			require => File["/etc/puppet/puppet.conf"],
	}
}


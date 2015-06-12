class puppet::install {
#	file { "/etc/apt/preferences.d/puppet-pin-900":
#		ensure => present,
#		source => "puppet:///modules/puppet/apt_preferences",
#	}   

	package { "puppet":
		ensure => present,
		provider => apt,
#		require => File["/etc/apt/preferences.d/puppet-pin-900"],
	}
}

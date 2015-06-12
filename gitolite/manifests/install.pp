class gitolite::install{

#	file { "/etc/apt/preferences.d/gitolite-pin-900":
#		ensure => present,
#		source => "puppet:///modules/gitolite/apt_preferences",
#	}

	package { ["git", "gitolite"]:
		ensure	=> installed,
		provider => apt,
#		require => File["/etc/apt/preferences.d/gitolite-pin-900"],
	}
}

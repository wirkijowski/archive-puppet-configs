#
# = Class: lxcusers::delubuntu
#	Deletes default lxc user - ubuntu
class lxcusers::delubuntu{
	package { "libshadow-ruby1.8":
		ensure => present,
	}

	user { "ubuntu":
		ensure => absent,
		password =>	'',
		require => Package["libshadow-ruby1.8"],
		provider => useradd,
	}

	file { "/home/ubuntu":
		ensure => absent,
	}
}

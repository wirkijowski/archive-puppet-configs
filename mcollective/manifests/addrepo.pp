
class mcollective::addrepo {
	file { "/etc/apt/sources.list.d/puppet.list":
		ensure => present,
		content => template("mcollective/puppet.list.erb"),
	}

	exec { "add_apt_puppetlabs_key":
		command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30",
	}
	exec { "apt-update_puppetlabs-repo":
		command => "/usr/bin/apt-get update",
		require => Exec["add_apt_puppetlabs_key"],
	}
	Exec {
		subscribe => File["/etc/apt/sources.list.d/puppet.list"],
		refreshonly => true,
	}
}

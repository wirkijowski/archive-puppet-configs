class containers::cgservices {
	file { "/etc/cgconfig.conf":
		ensure => present,
		source => "puppet:///modules/containers/cgconfig.conf",
	}

	file { "/etc/cgrules.conf":
		ensure => present,
		source => "puppet:///modules/containers/cgrules.conf",
	}

	File{
		require => Class["containers::install"],
	}

    service { "cgred":
    }
	service { "cgconfig":
#		status => "/etc/init.d/cgconfig status | /bin/grep \"Running\" > /dev/null 2>&1",
	}

	Service {
		enable => true,	
		ensure => true,
        require => File["/etc/cgconfig.conf", "/etc/cgrules.conf"],
#		hasstatus => true,
		hasrestart => true,
	}

}

class containers::install {
    package { ["lxc", "cgroup-bin", "libcgroup1", "bridge-utils" ]:
       ensure => present,
#       notify => Class["lxcpkg::disablecgsrv"],
    }

	file { "/var/lib/lxc":
		ensure => "directory",
		mode => 0755,
		require => Package["lxc", "cgroup-bin", "libcgroup1", "bridge-utils"],
	}
	file { "/var/lib/lxc/configs":
		ensure => directory,
		require => File["/var/lib/lxc"],
	}

}

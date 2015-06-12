
class ns::config {
	include ns::params

	file { "/var/cache/bind":
		ensure => present,
		source =>  "puppet:///files/ns/db",
		recurse => true,
	    owner => "bind",
		group => "bind",
		mode => 0644,
	}
	file { "/etc/bind/named.conf.local":
		ensure => present,
		source => "puppet:///files/ns/named.conf.local",
		owner => "root",
		group => "bind",
		mode => 0644,
	}
	file { "/etc/bind/named.conf.options":
		ensure => present,
		source => "puppet:///files/ns/named.conf.options",
		owner => "root",
		group => "bind",
		mode => 0644,
	}
	
	File {
		require => Class["ns::install"],
	}
}

class puppet::config {
#	include puppet::params

	file { "/etc/puppet/puppet.conf":
		ensure => present,
        source => $fqdn ? {
            'testing.net' => "puppet:///modules/puppet/puppet_testing.conf",
            default => "puppet:///modules/puppet/puppet.conf",
        },
	}

	file { "/etc/puppet/manifests/nodes.pp":
		ensure => present,
        source => "puppet:///modules/puppet/nodes.pp",
	}

	file { "/etc/puppet/manifests/site.pp":
		ensure => present,
        source => "puppet:///modules/puppet/site.pp",
	}
	file { "/etc/puppet/autosign.conf":
		ensure => present,
		source => "puppet:///modules/puppet/autosign.conf",
	}

	File {
		owner => "puppet",
		group => "puppet",
		require => Class["puppet::install"],
		notify => Class["puppet::service"],
		mode => 0644,
	}
}


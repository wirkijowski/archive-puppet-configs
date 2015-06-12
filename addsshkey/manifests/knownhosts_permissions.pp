class addsshkey::knownhosts_permissions{
	file { "/etc/ssh/ssh_known_hosts":
		mode => 644,
		owner => root,
		require => Class["addsshkey::knownhosts"],
	}
}

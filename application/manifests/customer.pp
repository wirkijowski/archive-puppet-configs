
define application::customer($customername, $key) {

  	file { "/var/lib/gitolite/gitolite-admin/keydir/${customername}.pub":
		ensure => present,
        content => $key,
		require => Class["gitolite::clone-admin"],
		owner => "gitolite",
		group => "gitolite",
	}

	exec { "${customername}_new_key":
		command => ["/bin/su gitolite -c \"/usr/bin/git add conf/repos/${customername}.conf \""],
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
		notify => Exec["${customername}_commit_new_key"],
	}


	exec { "${customername}_commit_new_key":
		command => "/bin/su gitolite -c \"/usr/bin/git commit conf/repos/${customername}.conf -m \"The new key for${customername}\"\"",
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
		notify => Exec["${customername}_push_new_key"],
	}

	exec { "${customername}_push_new_key":
		command => "/bin/su gitolite -c \"/usr/bin/git push origin\"",
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
	}
}

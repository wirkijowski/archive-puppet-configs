#
# = Class: gitolite::clone
#
# Clone admin repo as gitolite admin user
#
# TODO:
#	- add new fact about gitolite server

class gitolite::clone-admin {
	# ${puppetserver} is to be changed do ${gitserver}
	exec { "clone_gitolite-admin":
		command => "/bin/su gitolite -c \"/usr/bin/git clone git@${puppetserver}:gitolite-admin\"",
		cwd => "/var/lib/gitolite",
		subscribe => Class["gitolite::config"],
		refreshonly => true,
		require => Class["addsshkey::knownhosts",
		"addsshkey::knownhosts_permissions"],
	}

	#Every repo will be configured on its own config file and stored here
	file { "/var/lib/gitolite/gitolite-admin/conf/repos":
		ensure => directory,
		mode => 755,
		require => Exec["clone_gitolite-admin"],
	}


	file { "/var/lib/gitolite/gitolite-admin/conf/gitolite.conf":
		ensure => present,
		source => "puppet:///modules/gitolite/gitolite.conf",
		mode => 0644,
		owner => "gitolite",
		group => "gitolite",
		require => Exec["clone_gitolite-admin"],
	}

	exec { "gitolite-admin_add_config":
		command => "/bin/su gitolite -c \'/usr/bin/git add /var/lib/gitolite/gitolite-admin/conf/gitolite.conf\'",
		cwd => "/var/lib/gitolite/gitolite-admin",
		subscribe => File["/var/lib/gitolite/gitolite-admin/conf/gitolite.conf"],
		refreshonly => true,
	}

	exec { "gitolite-admin_commit_config":
		command => "/bin/su gitolite -c \'/usr/bin/git commit -m \"Main_configuration\"\'",
		cwd => "/var/lib/gitolite/gitolite-admin",
		subscribe => Exec["gitolite-admin_add_config"],
		refreshonly => true,
		notify => Exec["push_after_gitoliteadm-config"],
	}

	exec { "push_after_gitoliteadm-config":
		command => "/bin/su gitolite -c \"/usr/bin/git push origin\"",
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
	}


}

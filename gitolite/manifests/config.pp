#
# = Class: gitolite::config
#
# Configures gitolite for projects. Customers will push their
# projects as the git user. Gitolite user act as an admin 
class gitolite::config {

	user { "gitolite":
		ensure => present,
		home => "/var/lib/gitolite",
	}
	file { "/var/lib/gitolite":
		ensure => directory,
		mode => 0700,
		owner => "gitolite",
		group => "gitolite",
		require => User["gitolite"],
	}

	# generate ssh keys for gitolite user
	exec { "/usr/bin/ssh-keygen -q -N '' -f /var/lib/gitolite/.ssh/id_rsa":
		cwd => "/var/lib/gitolite",
		user => "gitolite",
		group => "gitolite",
		subscribe => File["/var/lib/gitolite"],
		refreshonly => true,
	}

	# customers' repos will be stored with git user
	user { "git":
		ensure => present,
		home => "/home/git",
	}
	file { "/home/git":
		ensure => directory,
		mode => 0700,
		owner => "git",
		group => "git",
		require => User["git"],
	}

	file { "/home/git/.gitconfig":
		ensure => present,
		content => template("gitolite/gitconfig.erb"),
		owner => "git",
		group => "git",
		require => File["/home/git"],
	}

	# admin's (gitolite) pub key
	file { "/tmp/gitolite.pub":
		ensure => present,
		source => "/var/lib/gitolite/.ssh/id_rsa.pub",
		require => Exec["/usr/bin/ssh-keygen -q -N '' -f /var/lib/gitolite/.ssh/id_rsa"],
	}
	# add admin's key to gitolite and setup gitolite system
	exec { "/bin/su - git /usr/bin/gl-setup /tmp/gitolite.pub":
		cwd => "/home/git",
		require => File["/tmp/gitolite.pub", "/home/git/.gitconfig"],
		unless => "/usr/bin/test -d /home/git/.gitolite",
	}

	file { "/var/lib/gitolite/.gitconfig":
		ensure => present,
		content => template("gitolite/gitconfig.erb"),
		owner => "gitolite",
		group => "gitolite",
		require => Class["gitolite::install"],
	}
}

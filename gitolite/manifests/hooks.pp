#
# = Class: gitolite::hooks
#
#	After gitolite system is set up, add post-recive hook.
#	This hook will deploy customer's project into appropriate container.
#	This has to be done on gitolite serve in gitolite's repo.
#

class gitolite::hooks {
	
	
	file { "/home/git/.gitolite/hooks/common/post-receive":
		require => Class["gitolite::config"],
		source => "puppet:///modules/gitolite/post-receive",
		owner => "git",
		group => "git",
		mode => 0744,
		ensure => present,
	}

	exec { "/bin/su - git /usr/bin/gl-setup":
		subscribe => File["/home/git/.gitolite/hooks/common/post-receive"],
		cwd => "/home/git",
		refreshonly => true,
	}

}

#
# = Definition: gitolite::addrepo
#
# Adds repo for a project
#
# Params:
#	- $reponame - for application it contains customer and application
#	name, it'll be also repo's user name
#	- $key - user's ssh key for repo; must be provided as cat printed it
#							eg. cat ~/.ssh/id_rsa.pub
#
#	TODO:
#		- more granural configuration for repo
#

define gitolite::addrepo($reponame, $customers_accounts){

#	file { "/var/lib/gitolite/gitolite-admin/keydir/${reponame}.pub":
#		content => $key,
#}


	file { "/var/lib/gitolite/gitolite-admin/conf/repos/${reponame}.conf":
		content	=> template("gitolite/repoconf.erb"),
		require => File["/var/lib/gitolite/gitolite-admin/conf/repos"],
	}
	
	
	File {
		ensure => present,
		mode => 0444,
		owner => "gitolite",
		group => "gitolite",
		#should require container
		require => [ Class["gitolite::clone-admin"], File["/var/lib/gitolite/gitolite-admin/keydir/${customers_accounts}.pub" ], ],
		notify => Exec["${reponame}_repo_config"],
	}

	exec { "${reponame}_repo_config":
		command => ["/bin/su gitolite -c \"/usr/bin/git add conf/repos/${reponame}.conf \""],
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
		notify => Exec["${reponame}_commit_newrepo_config"],
	}


	exec { "${reponame}_commit_newrepo_config":
		command => "/bin/su gitolite -c \"/usr/bin/git commit conf/repos/${reponame}.conf -m \"Configured the repo: ${reponame}\"\"",
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
		notify => Exec["${reponame}_push_newrepo_config"],
	}

	exec { "${reponame}_push_newrepo_config":
		command => "/bin/su gitolite -c \"/usr/bin/git push origin\"",
		cwd => "/var/lib/gitolite/gitolite-admin",
		refreshonly => true,
	}

}

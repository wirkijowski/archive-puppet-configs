#
# = Class: addsshkey::knownhosts
#
# Manages known host keys. 
#
# TODO:
#	- pull keys automagicaly from managed hosts


class addsshkey::knownhosts {

	sshkey { "XXX.net":
		ensure => present,
		type => "ssh-rsa",
		key => "",
	}

	sshkey { "testing01":
		ensure => present,
		type => "ssh-rsa",
		key => "",
		provider => parsed,
	}

}

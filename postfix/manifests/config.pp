
class postfix::config {

	file { "/etc/postfix/main.cf":
		ensure => present,
		require => Class["postfix::install"],
		content => template("postfix/main.cf.erb"),
	}

	exec { "reload_postfix_after_main.cf":
		command => "/usr/sbin/service postfix restart",
		refreshonly => true,
		subscribe => File["/etc/postfix/main.cf"],
	}
}


class mcollective::config {
	include mcollective::params
	$stomphost = $mcollective::params::stomphost

	file { "/etc/mcollective/server.cfg":
		ensure => present,
		content => template("mcollective/server.cfg.erb"),
		require => Class["mcollective::install"],
		owner => "root",
		group => "root",
		mode => 0640,
	}

	exec { "restart_mcollective":
		refreshonly => true,
		subscribe => File["/etc/mcollective/server.cfg"],
		command => "/usr/sbin/service mcollective restart",
	}
}

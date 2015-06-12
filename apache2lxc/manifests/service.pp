
class apache2lxc::service {
	include apache2lxc::params

	service { "apache2":
		ensure => $params::status,
		enable => $params::enabled,
		require => Class["apache2lxc::config"],
	}
}

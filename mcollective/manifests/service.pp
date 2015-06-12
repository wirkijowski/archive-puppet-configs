
class mcollective::service {
	service { "mcollective":
		ensure => stopped,
		enable => false,
		require => Class["mcollective::config"],
	}
}

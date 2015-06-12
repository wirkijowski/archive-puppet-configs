
class containers::service {

    
	service { "lxc":
		ensure => "running",
		enable => true,
	}

	service { "lxc-net":
		ensure => "running",
		enable => true,
	}
}

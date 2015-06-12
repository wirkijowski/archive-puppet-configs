

class containers::reload {

	exec { "reload_lxc_${customer}-${appname}":
		command => "/usr/sbin/service lxc reload",
        refreshonly => true, 
    }
}

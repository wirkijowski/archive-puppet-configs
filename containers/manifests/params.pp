
class containers::params {

#	$lxcdir = '/var/lib/lxc'

    case $operatingsystem {
		Debian: {
			$cg_services_status = 'stopped'
			$cg_services_enable = false
		}
		Ubuntu: {
			$cg_services_status = 'running'
			$cg_services_enable = true
		}
	}
}

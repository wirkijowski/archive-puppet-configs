

class apache2lxc::params {
	$disabledhosts = []

	if $hostname in $disabledhosts {
		$enabled = 'false'
		$status = 'stopped'
	} else {
		$enabled = 'true'
		$status = 'running'
	}
}

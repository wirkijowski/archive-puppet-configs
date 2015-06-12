
class mcollective::params {

	case $operatingsystem {
		/Ubuntu/:  { $stomppkg = $lsbdistcodename ? {
							'precise' => "ruby-stomp",
							'lucid' => "libstomp-ruby",
							}
					}
		default: { $stomppkg = "ruby-stomp" }
	}

	case $fqdn  {
		/^[\w-]+\.example\.net$/: { $stomphost = "x.x.x.x" }
		default: { $stomphost = "foo.example.net" }
	}
}

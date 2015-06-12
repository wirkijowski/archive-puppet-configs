
define customer::accounts($account, $key ) {

  	file { "/var/lib/gitolite/gitolite-admin/keydir/${account}.pub":
		ensure => present,
        content => $key,
		require => Class["gitolite::clone-admin"],
		owner => "gitolite",
		group => "gitolite",
	}
}

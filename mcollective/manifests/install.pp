
class mcollective::install {
	include mcollective::params

	$package = $mcollective::params::stomppkg

	package { $package :
		ensure => present,
		alias => "rubystomp",
	}
	package { "mcollective":
		ensure => present,
		require => [ Package["rubystomp"], Class["mcollective::addrepo"] ] ,
	}
}

#
# = Definition: containters::instance
#
# creates lxc instance
# Params:
#	- $customer - with appname is used to make lxc name
#	- $appname - as above
#	- $apptype - which lxc template use: 
#									* lamp_fcgi_phpX.X.XX
#									*
#	- $ip - ip number used by container
#

define containers::create( $customer, $appname, $apptype, $ip) {

	include containers, containers::params

    $lxcdir = '/var/lib/lxc'
	#conffile


	file { "${lxcdir}/configs/${customer}-${appname}_container.conf":
		ensure => present,
		content => template("containers/container.conf.erb"),
		require => Class["containers::install"],
	}

	#lxc-create
	#	$apptype => "lamp_fcgi_phpX.X.XX",
#	$lxctemplate = $apptype ? {
#		"lamp_fcgi_phpX.X.XX" => "debian",
#		"standard" => "ubuntu",
#		default => "ubuntu",
#	}
	$release = $apptype ? {
		"lamp_fcgi_phpX.X.XX" => "lucid",
		"standard" => "precise",
		default => "precise",
	}

	exec { "create_${customer}-${appname}":
		command => "/usr/bin/lxc-create -n ${customer}-${appname} -t ubuntu -f ${lxcdir}/configs/${customer}-${appname}_container.conf -- -r ${release}",
		cwd => $lxcdir,
		require => [ File["${lxcdir}/configs/${customer}-${appname}_container.conf"],
					Class["containers::cgservices"],
					Class["containers::lxcbr"] ],
		unless => "/usr/bin/lxc-ls | grep -q -P \"^${customer}-${appname}\$\" 2> /dev/null",
	}
		
	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/network/interfaces":
		ensure => present,
		mode => 0644,
		require => Exec["create_${customer}-${appname}"],
		content => template("containers/interfaces.erb"),
	}


	$networkfile = $release ? {
		lucid => "rc.local",
		precise => "init/network-interface.conf",
		default => "init/network-interface.conf",
	}

	$networkfilesource= $release ? {
		lucid => "rc.local",
		precise => "network-interface.conf",
		default => "network-interface.conf",
	}



	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/${networkfile}":
		ensure => present,
		mode => 0755,
		require => Exec["create_${customer}-${appname}"],
		source => "puppet:///modules/containers/${networkfilesource}",
	}

	file { "${lxcdir}/${customer}-${appname}/rootfs/var/www/":
		ensure => directory,
		mode => 0774,
		group => www-data,
		owner => git,
		require => Exec["create_${customer}-${appname}"],
	}

	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/hostname":
		ensure => present,
		require => Exec["create_${customer}-${appname}"],
		content => template("containers/hostname.erb"),
	}

	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/hosts":
		ensure => present,
		require => Exec["create_${customer}-${appname}"],
		content => template("containers/hosts.erb"),
	}

	if $release == 'lucid' {
		file { "${lxcdir}/${customer}-${appname}/rootfs/etc/apt/sources.list.d/lucid-backports.list":
			ensure => present,
			content => "deb http://archive.ubuntu.com/ubuntu lucid-backports main restricted universe multiverse",
			require => Exec["create_${customer}-${appname}"],
		}

		file { "${lxcdir}/${customer}-${appname}/rootfs/etc/apt/preferences.d/900-pin-puppet":
			ensure => present,
			source => "puppet:///containers/900-pin-puppet",
			require => Exec["create_${customer}-${appname}"],
		}

		exec { "apt-updt_backports_${customer}-${appname}":
			command => "/usr/sbin/chroot ${lxcdir}/${customer}-${appname}/rootfs apt-get update",
			refreshonly => true,
			subscribe => File["${lxcdir}/${customer}-${appname}/rootfs/etc/apt/sources.list.d/lucid-backports.list",
					"${lxcdir}/${customer}-${appname}/rootfs/etc/apt/preferences.d/900-pin-puppet"],
		}					

		exec { "puppet_for_${customer}-${appname}":
			command => "/usr/sbin/chroot ${lxcdir}/${customer}-${appname}/rootfs apt-get -y --force-yes install puppet facter",
			refreshonly => true,
			subscribe => Exec["create_${customer}-${appname}"],
			require => Exec["apt-updt_backports_${customer}-${appname}"],
		}
	} else {
		exec { "puppet_for_${customer}-${appname}":
			command => "/usr/sbin/chroot ${lxcdir}/${customer}-${appname}/rootfs apt-get -y --force-yes install puppet facter",
			refreshonly => true,
			subscribe => Exec["create_${customer}-${appname}"],
		}
	}

	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/default/puppet":
		ensure => present,
		require => Exec["puppet_for_${customer}-${appname}"],
		source => "puppet:///modules/containers/default_puppet",
	}
	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/puppet":
		ensure => directory,
		require => Exec["puppet_for_${customer}-${appname}"],
	}

	file { "${lxcdir}/${customer}-${appname}/rootfs/etc/puppet/puppet.conf":
		ensure => present,
        source => "puppet:///modules/puppet/puppet.conf",
		require => [Exec["puppet_for_${customer}-${appname}"],
				File["${lxcdir}/${customer}-${appname}/rootfs/etc/puppet"]],
	}


	File {
		mode => 0644,
#		notify => Exec["create_${customer}-${appname}"],
#		require => Class["containers::gettemplate", "containers::cgroups",
#		"containers::lxcbr"],
	}
	if $apptype == 'lamp_fcgi_phpX.X.XX' {
		file { "${lxcdir}/${customer}-${appname}/rootfs/usr/src/php5217.tar.gz":
			ensure => file,
			source => "/usr/src/php5217.tar.gz",
			recurse => true,
			require => Exec["create_${customer}-${appname}"],
		}
	}

	if $release == 'lucid' {
		file { "${lxcdir}/${customer}-${appname}/rootfs/etc/resolvconf/resolv.conf.d/tail":
			ensure => file,
			source => "/var/run/resolvconf/resolv.conf",
			require => Exec["create_${customer}-${appname}"],
		}
	}
}
	
#create repo -> gitolite::addrepo(reponame=${customer}-${appname})
#create varnish instance

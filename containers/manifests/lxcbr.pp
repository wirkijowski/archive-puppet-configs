#
# = Class: containers::lxcbr
#
# Configures bridge interface for lxc containers
#

class containers::lxcbr {
    file { "/etc/default/lxc":
        ensure => present,
        source => "puppet:///containers/lxc",
    }

    file { "/etc/init/lxc-net.conf":
        ensure => present,
        source => "puppet:///containers/lxc-net.conf",
    }
    
    File { 
        ensure => present,
        require => Class["containers::install"],
    }

  
    
#	exec { "add-bridge":
#		path => "/sbin",
#	    require => Class["containers::install"],
#		command => "brctl addbr br0 stp off setfd 0",
#		unless => "brctl show | /bin/grep br0",
#	}
#
#	exec { "bridge-address":
#		command => "/sbin/ip address add X.X.X.254/24 brd X.X.X.255 dev br0",
#		require => Exec["add-bridge"],
#	    unless => "/sbin/ip addr show dev br0 | /bin/grep -q X.X.X",	
#	}
#	exec { "bridge-up":
#		command => "/sbin/ip link set br0 up",
#		unless => "/sbin/ip link show br0 up | /bin/grep -q br0",
#		require => Exec["bridge-address"],
#	}
#
#	exec { "br0routing":
#		command => "/sbin/iptables -t nat -A POSTROUTING -s X.X.X.0/24 -j MASQUERADE",
#		unless => "/sbin/iptables -t nat -L POSTROUTING | /bin/grep -q X.X.X.0/24",
#		require => Exec["bridge-up"],
#	}

}


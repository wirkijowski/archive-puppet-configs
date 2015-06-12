#
# = Class: mcollective::plugins
#
# Downloads and activates mcollective plugins
#
# == Parameters:
#
#
# == Requires:
#	- mcollective::config
#	- "cd /usr/src && git clone git://github.com/puppetlabs/mcollective-plugins.git"
#
# == TODO:
#	- autoupdate distribution repo
#

class mcollective::plugins {

	$app = "/usr/share/mcollective/plugins/mcollective/agent"

	file { "${app}/puppetd.ddl":
		ensure => file,
		source => "puppet:///mcollective-plugins/agent/puppetd/agent/puppetd.ddl",
	}
	file { "${app}/puppetd.rb":
		ensure => file,
		source => "puppet:///mcollective-plugins/agent/puppetd/agent/puppetd.rb",
	}

    file { "${app}/apt.rb":
        ensure => file,
        source => "puppet:///mcollective-agents/apt/apt.rb",
    }

    file { "${app}/apt.ddl":
        ensure => file,
        source => "puppet:///mcollective-agents/apt/apt.ddl",
    }

	File {
		require => Class["mcollective::config"],
	}

#	exec { "mco_reload_agents":
#		refreshonly => true,
#		command => "/usr/bin/mco controller reload_agents",
#	}
}
		


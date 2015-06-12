class base {
	    include vim, addsshkey, puppet, mcollective
}

class lxchosts {
	include apache2lxc, mcollective, postfix, lxcusers
}

node "testing01.example.net" {
	include base, mysql, ns, puppet::params
		#, application
		
		application::customer { "wojtek":
			customername => "wojtek",
			key => '',
		}

		application::deploy { "app_wojtek-test":
			customer => "wojtek",
			appname => "test",
			apptype => "standard",
			ip => "",
			domain => "wojtek-test.example.net",
		}
		application::deploy { "app_wojtek-test2":
			customer => "wojtek",
			appname => "test2",
			apptype => "standard",
			ip => "",
			domain => "wojtek-test2.example.net",
		}

		application::deploy { "testowanie_aliasow":
            customer => "wojtek",
            accounts => ["wojtek",],
			appname => "aliasy",
			apptype => standard,
			ip => "",
			domain => "",
			vhost_aliases => $puppet::params::aliases,
		}
}


}

node /^[\w-]+\.lxc\.example\.net$/ {
	include lxchosts
}


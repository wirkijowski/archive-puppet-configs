
define application::deploy ($customer, $accounts=["$customer",], $appname, $apptype='standard', $ip, $domain, $vhost_aliases="www.${domain}") {

	include gitolite, containers, revproxy
#, varnish
	
#	application::customer{ "${customer}":
#		key => $key,"${customer}"
#	}

	gitolite::addrepo { "repo_${customer}-${appname}":
		reponame => "${customer}-${appname}",
		customers_accounts => $accounts,
		require => Application::Customer["${customer}"],
#		key => $key, 
		
	}   

	containers::instance { "container_${customer}-${appname}":
		customer => $customer,
		appname => $appname,
		apptype => $apptype,
		ip => $ip,
	 }   


	#revproxy::vhost ($customer, $appname, $domain, $backendip)
	revproxy::vhost { "vhost_${customer}-${appname}":
		domain => $domain,
		vhost_aliases => $vhost_aliases,
		backendip => $ip,
		customer => $customer,
		appname => $appname,
	}
	


}

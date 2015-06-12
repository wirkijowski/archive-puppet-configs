
class mcollective {
	include mcollective::addrepo, mcollective::install, mcollective::service,
		 mcollective::config, mcollective::plugins
}

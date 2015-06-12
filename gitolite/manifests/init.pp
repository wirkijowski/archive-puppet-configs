class gitolite {
	include gitolite::config, gitolite::hooks, gitolite::install,
			gitolite::clone-admin
}

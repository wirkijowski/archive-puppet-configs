# = Class: containers
#
#
class containers {
    include containers::install, containers::cgservices, 
			containers::lxcbr, containers::service


    stage { 'last': require => Stage['main'] }

    class {
        'containers::reload': stage => last;
    }
}


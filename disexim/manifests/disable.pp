class disexim::disable {
    service { "exim4":
        ensure => stopped,
        name => "exim4",
        provider => "debian",
        enable => false,
    }
}

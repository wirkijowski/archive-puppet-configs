class rmpmnfs::remove{
    package { ["portmap", "nfs-common", "rpcbind" ]:
        ensure => absent,
    }
}

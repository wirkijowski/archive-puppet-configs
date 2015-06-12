class addsshkey::authorized_key {
    ssh_authorized_key { "wojtek_laptop":
        ensure => present,
        key => ' ... ',
        name => 'wojtek@laptop',
        type => 'ssh-rsa',
        user => 'root',
    }

	ssh_authorized_key { " ... ":
        ensure => present,
        key => 'XXX',
        name => 'XXX',
        type => 'ssh-rsa',
        user => 'root',
    }




}

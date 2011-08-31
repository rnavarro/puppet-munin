# client.pp - configure a munin node
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class munin::client {
	module_dir { [ "munin", "munin/plugins" ]: }


	$munin_port_real = $munin_port ? { '' => 4949, default => $munin_port } 
	$munin_host_real = $munin_host ? {
		'' => '*',
		'fqdn' => '*',
		default => $munin_host
	}

	case $operatingsystem {
		darwin: { 
			include munin::client::darwin 
		}
		redhat: {
			include munin::client::redhat
		}
		centos: {
			info ( "Trying to configure ${operatingsystem}'s munin with RedHat class" )
			include munin::client::redhat
		}
		debian: {
			include munin::client::debian
			include munin::plugins::debian
		}
		ubuntu: {
			info ( "Trying to configure Ubuntu's munin with Debian class" )
			include munin::client::debian
			include munin::plugins::debian
		}
		default: { fail ("Don't know how to handle munin on $operatingsystem") }
	}

	case $kernel {
		linux: {
			case $vserver {
				guest: { include munin::plugins::vserver }
				default: {
					include munin::plugins::linux
					case $virtual {
						xen0: { include munin::plugins::xen }
					}
				}
			}
		}
		default: {
			err( "Don't know which munin plugins to install for $kernel" )
		}
	}

}

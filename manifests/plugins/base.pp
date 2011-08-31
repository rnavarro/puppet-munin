class munin::plugins::base {

	file {
		[ "/etc/munin/plugins", "/etc/munin/plugin-conf.d" ]:
			source => "puppet:///modules/common/empty",
			ensure => directory, checksum => mtime,
			ignore => '.ignore',
			recurse => true, purge => true, force => true,
			mode => 0755, owner => root, group => root,
			notify => Service[munin-node];
		"/etc/munin/plugin-conf.d/munin-node":
			source => [ "puppet:///modules/munin/munin-node.${lsbdistcodename}", "puppet:///modules/munin/munin-node" ],
			mode => 0644, owner => root, group => root,
			notify => Service[munin-node],
			before => Package[munin-node];
	}

}

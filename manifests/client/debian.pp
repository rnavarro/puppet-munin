class munin::client::debian
{

	package { "munin-node": ensure => installed }

	file {
		"/etc/munin/":
			ensure => directory,
			mode => 0755, owner => root, group => root;
		"/etc/munin/munin-node.conf":
			ensure => present,
			content => template("munin/munin-node.conf.${operatingsystem}.${lsbdistcodename}"),
			mode => 0644, owner => root, group => root,
			# this has to be installed before the package, so the postinst can
			# boot the munin-node without failure!
			before => Package["munin-node"],
			notify => Service["munin-node"],
	}

	service { "munin-node":
		ensure => running,
		# sarge's munin-node init script has no status
		hasstatus => $lsbdistcodename ? { sarge => false, default => true }
	}

	munin::register { $fqdn: }

	# workaround bug in munin_node_configure
	plugin { "postfix_mailvolume": ensure => absent }
}

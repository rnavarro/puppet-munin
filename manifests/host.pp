# host.pp - the master host of the munin installation
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class munin::host
{
	include munin::client
	include munin::common

	module_dir { [ "munin/nodes" ]: }

	package { [ "munin", "nmap"]: ensure => installed, }

	File <<| tag == 'munin' |>>

	concatenated_file { "/etc/munin/munin.conf":
		dir => "${munin::common::nodesdir}",
		header => "/etc/munin/munin.conf.header",
	}

	file {
		"/etc/munin/munin.conf.header":
			source => "/etc/munin/munin.conf",
			replace => no, # only initialise
			mode => 0644, owner => root, group => 0,
			before => File["/etc/munin/munin.conf"];
	}

	file { ["/var/log/munin-update.log", "/var/log/munin-limits.log",
	        "/var/log/munin-graph.log", "/var/log/munin-html.log"]:
		ensure => present,
		mode => 640, owner => munin, group => root;
  }

}

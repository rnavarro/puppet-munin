class munin::snmp_collector
{

	file {
		"${module_dir_path}/munin/create_snmp_links":
			source => "puppet:///modules/munin/create_snmp_links.sh",
			mode => 755, owner => root, group => root;
	}

	exec { "create_snmp_links":
		command => "${module_dir_path}/munin/create_snmp_links ${munin::common::nodesdir}",
		require => File["snmp_links"],
		timeout => "2048",
		schedule => daily
	}
}

define munin::register_snmp()
{
	include munin::common

	@@file { "munin_snmp_${name}": path => "${munin::common::nodesdir}/${name}",
		ensure => present,
		content => template("munin/snmpclient.erb"),
		tag => 'munin',
	}
}

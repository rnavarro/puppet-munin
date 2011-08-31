define munin::apache_site()
{
	apache::site {
		$name:
			ensure => present,
			content => template("munin/site.conf")
	}
}

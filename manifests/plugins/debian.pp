class munin::plugins::debian inherits munin::plugins::base {

	plugin { apt_all: ensure => present; }

}

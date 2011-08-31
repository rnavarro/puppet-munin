# plugin.pp - configure a specific munin plugin
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

define munin::plugin (
	$ensure = "present",
	$script_path = "/usr/share/munin/plugins",
	$config = '')
{
	debug ( "munin_plugin: name=$name, ensure=$ensure, script_path=$script_path" )
	$plugin = "/etc/munin/plugins/$name"
	$plugin_conf = "/etc/munin/plugin-conf.d/$name.conf"
	case $ensure {
		"absent": {
			debug ( "munin_plugin: suppressing $plugin" )
			file { $plugin: ensure => absent, } 
		}
		default: {
			$plugin_src = $ensure ? { "present" => $name, default => $ensure }
			debug ( "munin_plugin: making $plugin using src: $plugin_src" )
			file { $plugin:
				ensure => "$script_path/${plugin_src}",
				require => Package["munin-node"],
				notify => Service["munin-node"],
			}
		}
	}
	case $config {
		'': {
			debug("no config for $name")
			file { $plugin_conf: ensure => absent }
		}
		default: {
			case $ensure {
				absent: {
					debug("removing config for $name")
					file { $plugin_conf: ensure => absent }
				}
				default: {
					debug("creating $plugin_conf")
					file { $plugin_conf:
						content => "[${name}]\n$config\n",
						mode => 0644, owner => root, group => root,
					}
				}
			}
		}
	}
}

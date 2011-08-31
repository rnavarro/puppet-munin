define munin::remoteplugin($ensure = "present", $source, $config = '') {
	case $ensure {
		"absent": { munin::plugin{ $name: ensure => absent } }
		default: {
			file {
				"${module_dir_path}/munin/plugins/${name}":
					source => $source,
					mode => 0755, owner => root, group => root;
			}
			munin::plugin { $name:
				ensure => $ensure,
				config => $config,
				script_path => "${module_dir_path}/munin/plugins",
			}
		}
	}
}

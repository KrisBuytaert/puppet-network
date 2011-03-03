define network::alias(
		$ipaddress,
		$netmask,
		$network,
		$broadcast,
		$ensure) {
	$interface = $name

	$onboot = $ensure ? {
		up => "yes",
		down => "no"
	}

	file { "/etc/sysconfig/network-scripts/ifcfg-$interface":
		owner => root,
		group => root,
		mode => 600,
		content => template("network/sysconfig/network-scripts/ifcfg.interface.alias.erb"),
		alias => "ifcfg-$interface"
	}

	case $ensure {
		up: {
			exec { "ifup":
				command => "/sbin/ifdown $interface; /sbin/ifup $interface",
				subscribe => File["ifcfg-$interface"],
				refreshonly => true
			}
		}

		down: {
			exec { "ifdown":
				command =>"/sbin/ifdown $interface",
				subscribe => File["ifcfg-$interface"],
				refreshonly => true
			}
		}
	}
}

# Puppet-poudriere

Manage the FreeBSD PkgNG build system with Puppet.

## Simple Implementation

    poudriere::env { "90amd64":
      makeopts => [
        "WITH_PKGNG=yes",
        "OPTIONS_SET+= SASL",
        "OPTIONS_SET+= TLS",
        "WITH_IPV6=TRUE",
        "WITH_SSL=YES",
      ]
    }

    nginx::vhost { "build.${domain}":
      port      => 80,
      vhostroot => '/usr/local/poudriere_data/packages',
      autoindex => true,
    }


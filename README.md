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

## Changing default settings

The `poudriere` class has some default parameters for global settings, such as the ZFS pool, root filesystem, and the FreeBSD mirror site to use (see `init.pp` for details). To change these defaults, declare the `poudriere` class with your own parameters.

If you do not want to use ZFS, you can use:

    class { 'poudriere':
      zpool => false,
    }

## Using port-specific make options

You can pass port-specific make options as a hash in `pkg_makeopts`. For instance, if you want to build Apache 2.4 with the PHP 5.5 module, you can do the following:

    poudriere::env { "90amd64":
      makeopts => [
        'WITH_PKGNG=yes',
        'APACHE_VERSION=24',
        'APACHE_PORT=www/apache24',
      ],
      pkgs = [
        'www/apache24',
        'lang/php55',
      ],
      pkg_makeopts => {
        'lang/php55' => ['OPTIONS_SET+=APACHE'],
      },
    }

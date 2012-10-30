# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].

class poudriere (
  $zpool        = 'tank',
  $freebsd_host = 'http://ftp6.us.freebsd.org/',
  $ccache_dir   = '/usr/obj/ccache'
){

  Exec {
    path => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin',
  }

  # Install poudriere
  # make -C /usr/ports/ports-mgmt/poudriere install clean
  package { 'poudriere':
    ensure => installed,
  }

  file { '/usr/local/etc/poudriere.conf':
    content => template('poudriere/poudriere.conf.erb'),
    require => Package['poudriere'],
  }

  exec { "create default ports tree":
    command => "/usr/local/bin/poudriere ports -c",
    require => File["/usr/local/etc/poudriere.conf"],
    creates => '/usr/local/poudriere/ports/default',
    timeout => '1800',
  }

  file { "/usr/local/etc/poudriere.d":
    ensure  => directory,
    require => Exec["create default ports tree"],
  }

  file { "${ccache_dir}":
    ensure  => directory,
  }

}

# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].

class poudriere (
  $zpool             = 'tank',
  $zrootfs           = '/poudriere',
  $freebsd_host      = 'http://ftp6.us.freebsd.org/',
  $ccache_enable     = false,
  $ccache_dir        = '/var/cache/ccache',
  $poudriere_base    = '/usr/local/poudriere',
  $parallel_jobs     = $processorcount,
  $port_fetch_method = 'svn',
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
    command => "/usr/local/bin/poudriere ports -c -m ${port_fetch_method}",
    require => File["/usr/local/etc/poudriere.conf"],
    creates => '/usr/local/poudriere/ports/default',
    timeout => '3600',
  }

  file { "/usr/local/etc/poudriere.d":
    ensure  => directory,
    require => Exec["create default ports tree"],
  }

  if $ccache_enable {
    file { $ccache_dir:
      ensure => directory,
    }
  }

}

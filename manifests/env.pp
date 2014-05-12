# This define creates a build environment for a given release and archetecture
# of FreeBSD.  Passing in custom options gives you the bility to turn on and
# off certain features of your ports.  Anything that can build put in
# make.conf, you can put here as well.

# NOTE: This does not actually build the packages.  For that, you will want to
# read the documentation.

define poudriere::env (
  $makeopts      = [],
  $makefile      = nil,
  $version       = '10.0-RELEASE',
  $arch          = 'amd64',
  $jail          = $name,
  $paralleljobs  = $::processorcount,
  $pkgs          = [],
  $pkg_file       = nil,
  $pkg_makeopts  = {},
  $pkg_optsdir    = nil,
  $cron_enable   = false,
  $cron_interval = { minute => 0, hour => 0, monthday => '*', month => '*', weekday => '*' },
) {

  # Make sure we are prepared to run
  include poudriere

  # Create the environment
  exec { "create ${jail} jail":
    command => "/usr/local/bin/poudriere jail -c -j ${jail} -v ${version} -a ${arch}",
    require => Exec['create default ports tree'],
    creates => "${poudriere::poudriere_base}/jails/${jail}/",
    timeout => 3600,
  }

  $manage_make_source = $makefile ? {
    nil     => undef,
    default => $makefile,
  }

  $manage_make_content = $makeopts ? {
    []     => $pkg_makeopts ? {
      {} => undef,
      default => template('poudriere/make.conf.erb'),
    },
    default => template('poudriere/make.conf.erb'),
  }

  # Lay down the configuration
  file { "/usr/local/etc/poudriere.d/${jail}-make.conf":
    source  => $manage_make_source,
    content => $manage_make_content,
    require => File['/usr/local/etc/poudriere.d/'],
  }

  $manage_pkgs_source = $pkg_file ? {
    nil     => undef,
    default => $pkg_file,
  }

  $manage_pkgs_content = $pkgs ? {
    []      => undef,
    default => inline_template("<%= (@pkgs.join('\n'))+\"\n\" %>"),
  }

  # Define list of packages to build
  file { "/usr/local/etc/poudriere.d/${jail}.list":
    source  => $manage_pkgs_source,
    content => $manage_pkgs_content,
    require => File['/usr/local/etc/poudriere.d'],
  }

  # Define optional port building options
  if $pkg_optsdir != nil {
    file { "/usr/local/etc/poudriere.d/${jail}-options/":
      ensure  => directory,
      recurse => true,
      force   => true,
      source  => $pkg_optsdir,
    }
  }

  # build new ports periodically
  if $cron_enable == true {
   cron { "poudriere-bulk-${jail}":
     command  => "PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin poudriere bulk -f /usr/local/etc/poudriere.d/${jail}.list -j ${jail} -J ${paralleljobs}",
     user     => 'root',
     minute   => $cron_interval['minute'],
     hour     => $cron_interval['hour'],
     monthday => $cron_interval['monthday'],
     month    => $cron_interval['month'],
     weekday  => $cron_interval['weekday'],
   }
  }
}

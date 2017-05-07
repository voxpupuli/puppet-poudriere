# This resource creates a build environment for a given release and architecture
# of FreeBSD. Passing in custom options gives you the ability to turn on and
# off certain features of your ports. Specific make options you would put in
# make.conf, you can pass here as well.
# Automatic periodic building of packages is managed with the cron_enable
# parameter

define poudriere::env (
  $ensure           = 'present',
  $makeopts         = [],
  $makefile         = nil,
  $version          = '10.0-RELEASE',
  $arch             = 'amd64',
  $jail             = $name,
  $paralleljobs     = $::processorcount,
  $pkgs             = [],
  $pkg_file         = nil,
  $pkg_makeopts     = {},
  $pkg_optsdir      = nil,
  $portstree        = 'default',
  $cron_enable      = false,
  $cron_always_mail = false,
  $cron_interval    = { minute => 0, hour => 0, monthday => '*', month => '*', weekday => '*' },
) {

  # Make sure we are prepared to run
  include ::poudriere
  if ! defined(Poudriere::Portstree[$portstree]) {
    if $portstree == 'defaut' {
      warn('The default portstree is no longer created automatically.  Please consult the Readme file for instructions on how to create this yourself')
    } else {
      warn("portstree['${portstree}'] is not defined please consult the Readme for instructions on how to create this.")
    }
  }

  if $makefile != nil {
    $manage_make_source = $makefile
  }

  if $makeopts != [] or $pkg_makeopts != {} {
    $manage_make_content = template('poudriere/make.conf.erb')
  }

  if $pkg_file != nil {
    $manage_pkgs_source = $pkg_file
  }

  if $pkgs != [] {
    $manage_pkgs_content = inline_template("<%= (@pkgs.join('\n'))+\"\n\" %>")
  }

  $manage_file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  $manage_directory_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'directory',
  }

  # NOTE: directory cannot be defined absent
  # with recurse => true at the sime time:
  # https://tickets.puppetlabs.com/browse/PUP-2903
  $manage_directory_recurse = $ensure ? {
    'absent' => false,
    default  => true,
  }

  $manage_cron_ensure = $ensure ? {
    'absent' => 'absent',
    default => $cron_enable ? {
      true => 'present',
      default => 'absent',
    },
  }

  # Manage jail
  if $ensure != 'absent' {
    exec { "poudriere-jail-${jail}":
      command => "/usr/local/bin/poudriere jail -c -j ${jail} -v ${version} -a ${arch} -p ${portstree}",
      require => Poudriere::Portstree[$portstree],
      creates => "${poudriere::poudriere_base}/jails/${jail}/",
      timeout => 3600,
    }
  } else {
    exec { "poudriere-jail-${jail}":
      command => "/usr/local/bin/poudriere jail -d -j ${jail}",
      onlyif  => "/usr/local/bin/poudriere jail -l | /usr/bin/grep -w '^${jail}'",
    }
  }

  # Lay down the configuration
  file { "/usr/local/etc/poudriere.d/${jail}-make.conf":
    ensure  => $manage_file_ensure,
    source  => $manage_make_source,
    content => $manage_make_content,
    require => Exec["poudriere-jail-${jail}"],
  }

  # Define list of packages to build
  file { "/usr/local/etc/poudriere.d/${jail}.list":
    ensure  => $manage_file_ensure,
    source  => $manage_pkgs_source,
    content => $manage_pkgs_content,
    require => Exec["poudriere-jail-${jail}"],
  }

  # Define optional port building options
  if $pkg_optsdir != nil {
    file { "/usr/local/etc/poudriere.d/${jail}-options/":
      ensure  => $manage_directory_ensure,
      recurse => $manage_directory_recurse,
      force   => true,
      source  => $pkg_optsdir,
      require => Exec["poudriere-jail-${jail}"],
    }
  }

  if $cron_always_mail {
    $cron_command = "poudriere bulk -f /usr/local/etc/poudriere.d/${jail}.list -j ${jail} -J ${paralleljobs} -p ${portstree}"
  } else {
    $cron_command = "OUTPUT=\$(poudriere bulk -f /usr/local/etc/poudriere.d/${jail}.list -j ${jail} -J ${paralleljobs} -p ${portstree}) || echo \${OUTPUT}"
  }
  # Build new ports periodically
  cron { "poudriere-bulk-${jail}":
    ensure   => $manage_cron_ensure,
    command  => $cron_command,
    user     => 'root',
    minute   => $cron_interval['minute'],
    hour     => $cron_interval['hour'],
    monthday => $cron_interval['monthday'],
    month    => $cron_interval['month'],
    weekday  => $cron_interval['weekday'],
    require  => Exec["poudriere-jail-${jail}"],
  }
}

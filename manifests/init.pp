# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].
class poudriere (
  $zpool                  = 'tank',
  $zrootfs                = '/poudriere',
  $freebsd_host           = 'http://ftp6.us.freebsd.org/',
  $resolv_conf            = '/etc/resolv.conf',
  $ccache_enable          = false,
  $ccache_dir             = '/var/cache/ccache',
  $poudriere_base         = '/usr/local/poudriere',
  $poudriere_data         = '${BASEFS}/data',
  $use_portlint           = 'no',
  $mfssize                = '',
  $tmpfs                  = 'yes',
  $distfiles_cache        = '/usr/ports/distfiles',
  $csup_host              = '',
  $svn_host               = '',
  $check_changed_options  = 'verbose',
  $check_changed_deps     = 'yes',
  $pkg_repo_signing_key   = '',
  $parallel_jobs          = $::processorcount,
  $save_workdir           = '',
  $wrkdir_archive_format  = '',
  $nolinux                = '',
  $no_package_building    = '',
  $no_restricted          = '',
  $allow_make_jobs        = '',
  $url_base               = '',
  $max_execution_time     = '',
  $nohang_time            = '',
  $port_fetch_method      = 'svn',
  $http_proxy             = '',
  $ftp_proxy              = '',
  $cron_enable            = false,
  $cron_always_mail       = false,
  $cron_interval          = {minute => 0, hour => 22, monthday => '*', month => '*', week => '*'},
  $environments           = {},
  $portstrees             = {},
) {

  Exec {
    path => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin',
  }

  # Install poudriere and dialog4ports
  # make -C /usr/ports/ports-mgmt/poudriere install clean
  package { ['poudriere', 'dialog4ports']:
    ensure => installed,
  }

  file { '/usr/local/etc/poudriere.conf':
    content => template('poudriere/poudriere.conf.erb'),
    require => Package['poudriere'],
  }

  file { '/usr/local/etc/poudriere.d':
    ensure  => directory,
  }

  file { $distfiles_cache:
    ensure => directory,
  }

  if $ccache_enable {
    file { $ccache_dir:
      ensure => directory,
    }
  }

  # NOTE: cron_enable, cron_interval and port_fetch_method
  # are is deprecated and will eventually default to true.
  # portstree management has moved to poudriere::portstree
  if $cron_enable == true {
    notice('cron_enable, cron_interval and port_fetch_method on class poudriere is deprecated, define seperately poudriere::portstree')
  }

  cron { 'poudriere-update-ports':
    ensure   => 'absent',
  }

  # Create default portstree
  poudriere::portstree { 'default':
    fetch_method     => $port_fetch_method,
    cron_enable      => $cron_enable,
    cron_always_mail => $cron_always_mail,
    cron_interval    => $cron_interval,
  }

  # Create environments
  create_resources('poudriere::env', $environments)

  # Create portstrees
  create_resources('poudriere::portstree', $portstrees)
}
